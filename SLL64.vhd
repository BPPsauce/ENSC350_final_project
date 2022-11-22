library IEEE;
use IEEE.STD_LOGIC_1164.all;
Use ieee.numeric_std.all;
Use STD.TEXTIO.all;
use IEEE.MATH_REAL.ALL;

Entity SLL64 is
	Generic ( N : natural := 64 );
	Port ( X : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SLL64;

architecture bhv of SLL64 is
	component mux_4to1 is
	generic (datawidth : integer := 64);
	Port(
		  A,B,C,D : in STD_LOGIC_VECTOR(datawidth-1 downto 0);
		  S0,S1: in STD_LOGIC;
		  Z: out STD_LOGIC_VECTOR(datawidth-1 downto 0)
	);
end component;
	
	signal input : std_logic_vector (N-1 downto 0);
	signal mux1to2 : std_logic_vector(N-1 downto 0);
	signal mux2to3 : std_logic_vector(N-1 downto 0);
	signal result : std_logic_vector(N-1 downto 0);
	signal shift : std_logic_vector ( integer(ceil(log2(real(N))))-1 downto 0);
	signal zeroVec : std_logic_vector (N-1 downto 0);
	
begin
	Y <= result;
	zeroVec <= (others => '0');
	input <= X;
	shift <= std_logic_vector(ShiftCount);
	
	mux1 : mux_4to1 generic map (64)
											port map (A => zeroVec(47 downto 0) &  input((N-1)-48 downto 0), 
																	 B =>  zeroVec(31 downto 0) & input((N-1)-32 downto 0), 
																	 C=> zeroVec(15 downto 0) & input((N-1)-16 downto 0) , 
																	 D=> input((N-1) downto 0),
																	 S0 => shift(4), S1=> shift(5), 
																	 Z => mux1to2);
	
	mux2 : mux_4to1 generic map (64)
											port map (A =>  zeroVec(11 downto 0) &  mux1to2((N-1)-12 downto 0), 
																	 B =>  zeroVec(7 downto 0) &  mux1to2((N-1)-8 downto 0), 
																	 C=>  zeroVec(3 downto 0) &  mux1to2((N-1)-4 downto 0), 
																	 D=> mux1to2,
																	 S0 => shift(2), S1=> shift(3), 
																	 Z => mux2to3);
																	 
	mux3 : mux_4to1 generic map (64)
											port map (A =>   zeroVec(2 downto 0) &  mux2to3((N-1)-3 downto 0), 
																	 B =>   zeroVec(1 downto 0) &  mux2to3((N-1)-2 downto 0), 
																	 C=>  zeroVec(0 downto 0) &  mux2to3((N-1)-1 downto 0), 
																	 D=> mux2to3,
																	 S0 => shift(0), S1=> shift(1), 
																	 Z => result);	
end bhv; 