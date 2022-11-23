--64 bit Adder
library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


Entity Adder is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 );
			Y : out std_logic_vector( N-1 downto 0 );
	
	-- Control signals
	Cin : in std_logic;
	
	-- Status signals
	Cout, Ovfl : out std_logic );
End Entity Adder;

Architecture behaviour of Adder is
Signal Y_65 : std_logic_vector(N downto N-1); -- to get C_64 and Y(63)
Signal Y_64 : std_logic_vector(N-1 downto 0); -- to get C_63 and Y(62 downto 0)
Signal Cin_uns : unsigned(0 downto 0);
Signal C_63UNS : unsigned(0 downto 0);
Signal C_63STD : std_logic;
begin
	
	with Cin select
	Cin_uns <= to_unsigned(1, 1) when '1',
					to_unsigned(0, 1) when others;
		
	Y_64(N-1 DOWNTO 0) <= std_logic_vector(resize(unsigned(A(N-2 downto 0)), N) + resize(unsigned(B(N-2 downto 0)), N) + Cin_uns); -- do addition up to 63'd bit and record C_63
	C_63UNS <= ("" & Y_64(N-1));
	C_63STD <= Y_64(N-1);
	
	Y_65 <= std_logic_vector(resize(unsigned(A(N-1 downto N-1)), N-(N-2)) + resize(unsigned(B(N-1 downto N-1)), N-(N-2)) + C_63UNS); -- do addition for 64th and 65th(Cout) spot
	Cout <= Y_65(N);
	
	--Y_65 <= std_logic_vector(resize(unsigned(A), N+1) + resize(unsigned(B), N+1) + Cin_uns);
	--Cout <= Y_65(N);
	
	Y(N-1) <= Y_65(N-1); -- ignore the Y(64) as we saved it into Cout
	Y(N-2 downto 0) <= Y_64(N-2 downto 0); -- ignore the Y(63) value as it was just the C_63
	Ovfl <= Cout XOR C_63STD; -- Overflow
	
end Architecture;