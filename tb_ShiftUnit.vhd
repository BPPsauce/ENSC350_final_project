library IEEE;
use IEEE.STD_LOGIC_1164.all;
Use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

Entity tb_ShiftUnit is
	Generic ( N : natural := 64 );
	Port ( A, B, C : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftFN : in std_logic_vector( 1 downto 0 );
					ExtWord : in std_logic );
End Entity tb_ShiftUnit;

Architecture test of tb_ShiftUnit is
	Component 	ShiftUnit is
	Generic ( N : natural := 64 );
	Port ( A, B, C : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftFN : in std_logic_vector( 1 downto 0 );
					ExtWord : in std_logic );
End Component;

--signal count : unsigned (integer(ceil(log2(real(N))))-1 downto 0 );
signal inputA : std_logic_vector(N-1 downto 0);
signal inputB : std_logic_vector(N-1 downto 0);
signal inputC : std_logic_vector(N-1 downto 0);
signal ShiftFNSig : std_logic_vector (1 downto 0);
signal extWordSig : std_logic;
signal output : std_logic_vector(N-1 downto 0);

begin 
DUT: ShiftUnit
port map ( A => inputA, B => inputB, C => inputC, 
			  Y => output,
			  ShiftFN => ShiftFNSig,
			  ExtWord => extWordSig);

process is 
begin 
--80NS failure

inputA <= "1111000010100101111100001100001111110000101001011111000011000011";
inputB <= "0000111101011010111100000011110000001111010110101111000000111100";
inputC <= "0000000000000000111000010000000000000000000000001110000011111111";
--expected -> 0000E1000000E0FF
ShiftFNSig <= "00";
extWordSig <= '0';
wait for 20 ns;


--120 NS failure
inputA <= "1111000010100101111100001100001111110000101001011111000011000011";
inputB <= "0000111101011010111100000011110000001111010110101111000000111100";
inputC <= "0000000000000000111000010000000000000000000000001110000011111111";
--expected -> E0FF
ShiftFNSig <= "00";
extWordSig <= '1';
wait for 20 ns;


--200 ns failure
inputA <= "1111000010100101111100001100001111110000101001011111000011000011";
inputB <= "0000111101011010111100000011110000001111010110101111000000111100";
inputC <= "1110000101001011000000001000011111100001010010110000000010000111";
--expected -> 300000000000000
ShiftFNSig <= "01";
extWordSig <= '0';
wait for 20 ns;

-- 260
inputA <= "1000000000000000000000000000010010001111111111111111111111111111";
inputB <= "0000000000000000000000000000000000000000000000000000000000000001";
inputC <= "1110000101001011000000001000011111100001010010110000000010000111";
--expected -> 0000000030000000
ShiftFNSig <= "01";
extWordSig <= '1';
wait for 20 ns;

--280
inputA <= "1000000000000000000000000000010010001111111111111111111111111111";
inputB <= "0000000000000000000000000000000000000000000000000000000000000001";
inputC <= "1110000101001011000000001000011111100001010010110000000010000111";
--expected -> F
ShiftFNSig <= "10";
extWordSig <= '1';
wait for 20 ns;
wait;

end process;

end test;