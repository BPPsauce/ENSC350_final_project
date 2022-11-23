library IEEE;
use IEEE.STD_LOGIC_1164.all;
Use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

Entity SRA64 is
	Generic ( N : natural := 64 );
	Port ( X : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SRA64;

architecture bhv of SRA64 is
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
	
	--signal SRA48 : signed(N-1 downto 0);
	
begin
	Y <= result;
	input <= X;
	shift <= std_logic_vector(ShiftCount);
	
	mux1 : mux_4to1 generic map (64)
											port map (A => std_logic_vector(shift_right(signed(input), 48)), 
																	 B =>  std_logic_vector(shift_right(signed(input), 32)), 
																	 C=>  std_logic_vector(shift_right(signed(input), 16)) , 
																	 D=>  std_logic_vector(shift_right(signed(input), 0)),
																	 S0 => shift(5), S1=> shift(4), 
																	 Z => mux1to2);
	
	mux2 : mux_4to1 generic map (64)
											port map (A =>  std_logic_vector(shift_right(signed(mux1to2), 12)), 
																	 B =>  std_logic_vector(shift_right(signed(mux1to2), 8)), 
																	 C=>  std_logic_vector(shift_right(signed(mux1to2), 4)), 
																	 D=> std_logic_vector(shift_right(signed(mux1to2), 0)),
																	 S0 => shift(3), S1=> shift(2), 
																	 Z => mux2to3);
																	 
	mux3 : mux_4to1 generic map (64)
											port map (A => std_logic_vector(shift_right(signed(mux2to3), 3)), 
																	 B => std_logic_vector(shift_right(signed(mux2to3), 2)), 
																	 C=> std_logic_vector(shift_right(signed(mux2to3), 1)), 
																	 D=> std_logic_vector(shift_right(signed(mux2to3), 0)),
																	 S0 => shift(1), S1=> shift(0), 
																	 Z => result);	
end bhv; 