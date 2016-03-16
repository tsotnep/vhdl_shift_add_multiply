library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shift_add_mult is
	generic(
		size : integer := 5
	);
end entity tb_shift_add_mult;

architecture RTL of tb_shift_add_mult is
	signal answer_out    : std_logic_vector(size * 2 - 1 downto 0);
	signal a_in          : std_logic_vector(size - 1 downto 0);
	signal ans_ready_out : std_logic := '0';
	signal start_calc_in : std_logic := '0';
	signal b_in          : std_logic_vector(size - 1 downto 0);
	signal clk           : std_logic := '0';
	signal rst           : std_logic := '1';
	constant clk_period  : time      := 2 ns;

begin
	top_level_mult_inst : entity work.MULTIPLIERENTITY
		generic map(
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
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process clock_driver;

	stimul : process is
	begin
		wait for 5 ns;
		rst <= '1';
		wait for clk_period * 2;

		for a in 0 to 2 ** size - 1 loop
			for b in 0 to 2 ** size - 1 loop
				a_in <= std_logic_vector(to_unsigned(a, size));
				b_in <= std_logic_vector(to_unsigned(b, size));
				wait for clk_period;
				start_calc_in <= '1';
				wait for clk_period;
				start_calc_in <= '0';
				wait until ans_ready_out = '1';
				assert (to_integer(unsigned(a_in)) * to_integer(unsigned(b_in)) = to_integer(unsigned(answer_out))) report "a_in * b_in /= answer_out" severity failure;
				wait for clk_period * 2;
			end loop;
		end loop;
		
		wait;
	end process stimul;

end architecture RTL;

