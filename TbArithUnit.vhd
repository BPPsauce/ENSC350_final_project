--TbArithUnit

library ieee;
use ieee.std_logic_1164.all;


entity TbArithUnit is
	Generic (N : Natural := 64);
end TbArithUnit;

architecture tb of TbArithUnit is
    signal A_tb, B_tb : std_logic_vector(N-1 downto 0);
	 signal Cin_tb : std_logic;
	 signal AddNSub_tb, ExtWord_tb : std_logic;
    signal Y_tb, AddY_tb : std_logic_vector(N-1 downto 0);
	 signal Cout_tb, Ovfl_tb, Zero_tb, AltB_tb, AltBu_tb : std_logic;
begin
    -- connecting testbench signals with half_adder.vhd
    DUT : entity work.ArithUnit port map (A => A_tb, B => B_tb, Y => Y_tb, AddY => AddY_tb, AddnSub => AddnSub_tb, Zero => Zero_tb, 
														ExtWord => ExtWord_tb, AltB => AltB_tb, AltBu => AltBu_tb, Cout => Cout_tb, Ovfl => Ovfl_tb);

    -- inputs
	 
	 Process
	 begin
		A_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000001";
		ExtWord_tb <= '0';
		AddnSub_tb <= '0';
		wait for 20 ns;
		A_tb <= "1000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0100000000000000000000000000000000000000000000000000000000000001";
		ExtWord_tb <= '1';
		AddnSub_tb <= '0';
		wait for 20 ns;
		A_tb <= "0000000000000100000000000000000000000000000000000000000000000011";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000001";
		ExtWord_tb <= '0';
		AddnSub_tb <= '1';
		wait for 20 ns;
		A_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000001";
		ExtWord_tb <= '0';
		AddnSub_tb <= '1';
		wait for 20 ns;
		A_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		ExtWord_tb <= '0';
		AddnSub_tb <= '1';
		wait for 20 ns;
		A_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		B_tb <= "0000000000000000000000000000000000000000000000000000000000000011";
		ExtWord_tb <= '1';
		AddnSub_tb <= '1';
		wait for 20 ns;
		
		wait;
	 end process;
		
end tb ;