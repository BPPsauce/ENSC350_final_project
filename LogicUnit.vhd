library ieee;
use ieee.std_logic_1164.all;

Entity LogicUnit is
Generic ( N : natural := 64 );
Port ( A, B : in std_logic_vector( N-1 downto 0 );
Y : out std_logic_vector( N-1 downto 0 );
LogicFN : in std_logic_vector( 1 downto 0 ) );
End Entity LogicUnit;

architecture Behavior of LogicUnit is

signal ad : std_logic_vector (N-1 downto 0);
signal o : std_logic_vector (N-1 downto 0);
signal x : std_logic_vector (N-1 downto 0);


begin

ad <= (A And B);
o <= (A Or B);
x <= (A Xor B);

with LogicFn select 
    Y <= B when "00",
        x when "01",
        o when "10",
        ad when "11",
        B when others;
	
End Behavior;