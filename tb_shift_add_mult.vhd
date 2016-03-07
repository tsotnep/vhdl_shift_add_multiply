library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shift_add_mult is
	generic(
		size : integer := 4
	);
end entity tb_shift_add_mult;

architecture RTL of tb_shift_add_mult is
	signal answer_out    : std_logic_vector(size * 2 - 1 downto 0);
	signal a_in          : std_logic_vector(size - 1 downto 0);
	signal ans_ready_out : std_logic;
	signal start_calc_in : std_logic;
	signal b_in          : std_logic_vector(size - 1 downto 0);
	signal clk           : std_logic;
	signal rst           : std_logic;

begin
	top_level_mult_inst : entity work.top_level_mult
	  generic map (
			size => size
		)
		port map(
			answer_out    => answer_out,
			ans_ready_out => ans_ready_out,
			a_in          => a_in,
			b_in          => b_in,
			start_calc_in => start_calc_in,
			clk           => clk,
			rst           => rst
		);

	clock_driver : process
		constant period : time := 10 ns;
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clock_driver;

	stimul : process is
	begin
		wait for 5 ns;
		rst <= '1';
		start_calc_in <= '0';
		wait for 10 ns;
		rst <= '0';
		a_in <= "1111";
		b_in <= "1111";
		start_calc_in <= '1';
		wait for 10 ns;
		start_calc_in <= '0';


		wait for 100 ns;
		wait;
	end process stimul;

end architecture RTL;
