library IEEE;
use IEEE.STD_LOGIC_1164.all;
Use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

Entity tb_SLL64 is
	Generic ( N : natural := 64 );
	Port ( X : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity tb_SLL64;

Architecture test of tb_SLL64 is
	Component 	SLL64 is
	Port ( X : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Component;

signal count : unsigned (integer(ceil(log2(real(N))))-1 downto 0 );
signal input : std_logic_vector(N-1 downto 0);
signal output : std_logic_vector(N-1 downto 0);

begin 
DUT: SLL64
port map (X => input, Y => output, ShiftCount => count);

process is 
begin 

input <= "0000000000000000000000000000010000000000000000000000000000000000";
count <= "001000";
wait for 200 ns;

input <= "0000000000000000000000000000010000000000000000000000000000000000";
count <= "001110";
wait for 200 ns;

input <= "0000000000000000000000000000010000000000000000000000000000000000";
count <= "000001";
wait for 200 ns;

input <= "0000000000000000000000000000000000000000000000000000000000001000";
count <= "000010";
wait for 200 ns;

input <= "0000000000000000000000000000000000000000000000000000000000001000";
count <= "000000";
wait for 200 ns;


input <= "0000000000000000000000000000000000000000000000000000000000001000";
count <= "100000";
wait for 200 ns;
wait;

end process;

end test;