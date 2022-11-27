library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--Execution Unit
Entity ExecUnit is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 );	
	FuncClass, LogicFN, ShiftFN : in std_logic_vector( 1 downto 0 );
	AddnSub, ExtWord : in std_logic := '0';
	Y : out std_logic_vector( N-1 downto 0 );
	Zero, AltB, AltBu : out std_logic );
End Entity ExecUnit;


Architecture Exec of ExecUnit is

Component ArithUnit is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 );
			AddY : out std_logic_vector( N-1 downto 0 );
			
			-- Control signals
			AddnSub : in std_logic := '0';
	
			-- Status signals
			Cout, Ovfl, Zero, AltB, AltBu : out std_logic );
end Component;

Component LogicUnit is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 );
			Y : out std_logic_vector( N-1 downto 0 );
			LogicFN : in std_logic_vector( 1 downto 0 ) );
end Component;

Component ShiftUnit is
Generic ( N : natural := 64 );
	Port ( A, B, C : in std_logic_vector( N-1 downto 0 );
			Y : out std_logic_vector( N-1 downto 0 );
			ShiftFN : in std_logic_vector( 1 downto 0 );
			ExtWord : in std_logic );
end Component;

Signal ArithUnit_Out : std_logic_vector(N-1 downto 0);
Signal LogicUnit_Out : std_logic_vector(N-1 downto 0);
Signal ShiftUnit_Out : std_logic_vector(N-1 downto 0);
Signal AltB_Carrier : std_logic_vector(N-1 downto 0);

begin
	
	u1: ArithUnit Port Map (A => A, B => B, AddY => ArithUnit_out, AddnSub => AddnSub, Zero => Zero, AltB => AltB, AltBu => AltBu);
	u2: LogicUnit Port Map (A => A, B => B, Y => LogicUnit_Out, LogicFN => LogicFN);
	u3: ShiftUnit Port Map (A => A, B => B, C => ArithUnit_Out, Y => ShiftUnit_Out, ShiftFN => ShiftFN, ExtWord => ExtWord);
	
	with FuncClass select
		Y <= ShiftUnit_Out when "00",
			  LogicUnit_Out when "01",
			  AltB_Carrier(N-1 downto 1) & AltB when "10",
			  AltB_Carrier(N-1 downto 1) & AltB when "11";
	
end Architecture;