library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- simulation: http://prnt.sc/afcsp3

entity MULTIPLIERENTITY is
	generic(
		size : integer
	);
	port(
		answer_out    : out std_logic_vector(size * 2 - 1 downto 0);
		ans_ready_out : out std_logic;
		a_in          : in  std_logic_vector(size - 1 downto 0);
		b_in          : in  std_logic_vector(size - 1 downto 0);
		start_calc_in : in  std_logic;
		clk           : in  std_logic;
		rst           : in  std_logic
	);
end entity MULTIPLIERENTITY;

architecture RTL of MULTIPLIERENTITY is
	constant irq_width : integer := 4;  --should be <= 15

	type state is (wait_for_input_st, calculate_st, generate_interrupt_st);
	signal current_state, next_state : state                                   := wait_for_input_st;
	signal ans_store, result         : std_logic_vector(size * 2 - 1 downto 0) := (others => '0');
	signal a_store                   : std_logic_vector(size * 2 - 1 downto 0) := (others => '0');
	signal b_store                   : std_logic_vector(size - 1 downto 0)     := (others => '0');
	signal interrupt                 : std_logic_vector(3 downto 0)            := std_logic_vector(to_unsigned(irq_width, 4));
	signal start_calc_trig           : std_logic                               := '0';
begin
	answer_out <= result when (current_state /= calculate_st) else (others => '0');
	process(clk, rst)
	begin
		if rst = '0' then
			current_state <= wait_for_input_st;
		elsif rising_edge(clk) then
			current_state <= next_state;
			case current_state is
				when wait_for_input_st =>
					ans_ready_out <= '0';
					interrupt     <= std_logic_vector(to_unsigned(irq_width, 4));
					start_calc_trig <= start_calc_in;
					if start_calc_trig = '0' and start_calc_in = '1' then
						next_state                     <= calculate_st;
						a_store(size * 2 - 1 downto 0) <= (others => '0');
						a_store(size - 1 downto 0)     <= a_in;
						b_store                        <= b_in;
						result                         <= (others => '0');
						ans_store                      <= (others => '0');
					end if;

				when calculate_st =>
					if b_store = (b_store'range => '0') then
						next_state <= generate_interrupt_st; --if calculation is finished, generate interrupt
					else
						a_store <= a_store(a_store'left - 1 downto 0) & '0'; --shift to the right
						b_store <= '0' & b_store(b_store'left downto 1); --shift to the left
						if b_store(0) = '1' then
							ans_store <= std_logic_vector(unsigned(ans_store) + unsigned(a_store)); --if b's LSB is '1' add a into answer/result
						end if;
					end if;

				when generate_interrupt_st =>
					if interrupt = (interrupt'range => '0') then
						next_state <= wait_for_input_st; --when interrupt width is decremented irq_width -times, we go into init state
						ans_ready_out <= '0';
					else
						interrupt     <= std_logic_vector(unsigned(interrupt) - 1); --to generate pulse of irq with width of : irq_width	
						result        <= ans_store;
						ans_ready_out <= '1';
					end if;

			end case;
		end if;
	end process;

end architecture RTL;

