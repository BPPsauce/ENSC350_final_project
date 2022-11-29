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
	
	--Use AddnSub to determine if we want to invert B or not
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
		
	-- Altb and AltBu
	Process(A,B) is
	begin
		--compare signed values A and B
		if signed(A) < signed(B) then
			AltB <= '1';
		else
			AltB <= '0';
		end if;
		--compare unsigned values A and B
		if unsigned(A) < unsigned(B) then
			AltBu <= '1';
		else
			AltBu <= '0';
		end if;
	end Process;
	
end Architecture;