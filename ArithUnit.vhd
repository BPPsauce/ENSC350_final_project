-- Arithmetic Unit
library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity ArithUnit is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 );
			AddY : out std_logic_vector( N-1 downto 0 );
			
	-- Control signals
	AddnSub : in std_logic := '0';
	
	-- Status signals
	Cout, Ovfl, Zero, AltB, AltBu : out std_logic );
End Entity ArithUnit;

Architecture behaviour of ArithUnit is

Component Adder is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 );
			Y : out std_logic_vector( N-1 downto 0 );
	
	-- Control signals
	Cin : in std_logic;
	
	-- Status signals
	Cout, Ovfl : out std_logic );
end Component;

Signal B_Inverted : std_logic_vector(N-1 downto 0);
Signal B_AdderInput : std_logic_vector(N-1 downto 0);
Signal Y_AdderOut : std_logic_vector(N-1 downto 0);
Signal Y_SgnExt : std_logic_vector(N-1 downto 0);

begin
	

	B_Inverted <= NOT B;

	With AddnSub Select
		B_AdderInput <= B_Inverted when '1',
				B when others;
	
	u1: Adder port map  (A => A, B => B_AdderInput, Y => Y_AdderOut, Cin => AddnSub, Cout => Cout, Ovfl => Ovfl);
	
	--Create Zero flag
	With Y_AdderOut Select
		Zero <= '1' when "0000000000000000000000000000000000000000000000000000000000000000", -- Y_Adder out is all zeroes
			'0' when others;
	
	-- AddY
	AddY <= Y_AdderOut;
	
	--get Sign extended version of Y
	-- Y_SgnExt(63 downto 32) <= (Others => Y_AdderOut(63));
	-- Y_SgnExt(31 downto 0) <= Y_AdderOut(31 downto 0);
	
	--With ExtWord Select
	--	Y <= Y_SgnExt when '1',
	--		  AddY when others;
		
	-- Altb
	with Cout Select
		AltBu <= '0' when '1',
				   '1' when others;
					
	--what to do with overflow?
	with Cout Select
		AltB <= '0' when '1',
				  '1' when others;
end Architecture;