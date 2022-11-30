library ieee;
use ieee.std_logic_1164.all;

Entity tb_LogicUnit is
	Generic ( N : natural := 64 );
	Port ( 	A, B : in std_logic_vector( N-1 downto 0 );
				Y : out std_logic_vector( N-1 downto 0 );
				LogicFN : in std_logic_vector( 1 downto 0 ) );
End Entity tb_LogicUnit;

Architecture behavior of tb_LogicUnit is
	Component	LogicUnit	is
	Port ( 	A, B : in std_logic_vector( N-1 downto 0 );
				Y : out std_logic_vector( N-1 downto 0 );
				LogicFN : in std_logic_vector( 1 downto 0 ) );
	End Component;

--Create internal Signal	
Signal Fn : std_logic_vector( 1 downto 0 );
Signal input1 : std_logic_vector( N-1 downto 0 );
Signal input2 : std_logic_vector( N-1 downto 0 );
Signal output : std_logic_vector( N-1 downto 0 );

Begin
DUT: LogicUnit
port map (A => input1, B => input2, Y => output, LogicFn => Fn);

process is 
begin
--Test case For Lui
input1 <= "0000000000000000000000000000000000000000000000000000000000000000";
input2 <= "0000000000000000000000000000000000000000000000000000000000011111";
Fn <= "00";
wait for 20 ns;
--Test case for xor
input1 <= "0000000000000000000000000000000000000000000000000000000000000000";
input2 <= "0000000000000000000000000000000000000000000000000000000000011111";
Fn <= "01";
wait for 20 ns;
--Test case for or
input1 <= "0000000000000000000000000000000000000000000000000000000000000000";
input2 <= "0000000000000000000000000000000000000000000000000000000000011111";
Fn <= "10";
wait for 20 ns;
--Test case for and
input1 <= "0000000000000000000000000000000000000000000000000000000000000000";
input2 <= "0000000000000000000000000000000000000000000000000000000000011111";
Fn <= "11";
wait for 20 ns;


wait;

end process;

end behavior;
