--Tb for Adder

library ieee;
use ieee.std_logic_1164.all;


entity TbAdder is
	Generic (N : Natural := 64);
end TbAdder;

architecture tb of TbAdder is
    signal A_tb, B_tb : std_logic_vector(N-1 downto 0);
	 signal Cin_tb : std_logic;
    signal Y_tb : std_logic_vector(N-1 downto 0);
	 signal Cout_tb, Ovfl_tb : std_logic;
begin
    -- connecting testbench signals with half_adder.vhd
    DUT : entity work.Adder port map (A => A_tb, B => B_tb, Y => Y_tb, Cout => Cout_tb, Ovfl => Ovfl_tb, Cin => Cin_tb);

    -- inputs
	 
	 Process
	 begin
		A_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000001";
		Cin_tb <= '1';
		wait for 20 ns;
		A_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000001";
		Cin_tb <= '0';
		wait for 20 ns;
		
		A_tb <= "1000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0100000000000000000000000000000000000000000000000000000000000001";
		Cin_tb <= '1';
		wait for 20 ns;
		
		A_tb <= "0000000000000000000000000000000000000000000000000000000000000000";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000001";
		Cin_tb <= '1';
		wait for 20 ns;
		
		wait;
	 end process;
		
end tb ;