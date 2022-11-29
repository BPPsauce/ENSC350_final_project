library IEEE;
use IEEE.STD_LOGIC_1164.all;
Use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;
Use STD.TEXTIO.all; -- for file read functions

Entity tb_ExecUnit is
	Generic ( N : natural := 64 );

	Port ( A, B : in std_logic_vector( N-1 downto 0 );	
	FuncClass, LogicFN, ShiftFN : in std_logic_vector( 1 downto 0 );
	AddnSub, ExtWord : in std_logic := '0';
	Y : out std_logic_vector( N-1 downto 0 );
	Zero, AltB, AltBu : out std_logic );

End Entity tb_ExecUnit;


Architecture testbench of tb_ExecUnit is

--importing the component
Component ExecUnit is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 );	
	FuncClass, LogicFN, ShiftFN : in std_logic_vector( 1 downto 0 );
	AddnSub, ExtWord : in std_logic := '0';
	Y : out std_logic_vector( N-1 downto 0 );
	Zero, AltB, AltBu : out std_logic );
End Component;
--end of component

signal inputA : std_logic_vector(N-1 downto 0);
signal inputB : std_logic_vector(N-1 downto 0);
signal FuncClassIn : std_logic_vector (1 downto 0);
signal LogicFNIn : std_logic_vector (1 downto 0);
signal ShiftFNIn : std_logic_vector (1 downto 0);
signal AddnSubIn : std_logic;
signal ExtWordIn : std_logic;
signal resultY : std_logic_vector(N-1 downto 0);
signal ZeroIn : std_logic;
signal AltBIn : std_logic;
signal AltBuIn : std_logic;


begin 
DUT: ExecUnit
port map (A => inputA, B => inputB,
	  FuncClass => FuncClassIn, LogicFN => LogicFNIn, ShiftFN => ShiftFNIn,
	  AddnSub => AddnSubIn, ExtWord => ExtWordIn,
	  Y => resultY, 
	  Zero => ZeroIn, AltB => AltBIn, AltBu => AltBuIn);


--file read process
--Main : process (inputA, inputB, FuncClassIn, LogicFNIn, ShiftFNIn, AddnSubIn, ExtWordIn) is
Main : process 
--constant Num_col : integer := 9; -- number of col in the file


Variable Avar : std_logic_vector(N-1 downto 0);
Variable Bvar : std_logic_vector(N-1 downto 0);
Variable FuncClassVar : std_logic_vector(1 downto 0);
Variable LogicFNVar : std_logic_vector(1 downto 0);
Variable ShiftFNVar : std_logic_vector(1 downto 0);
Variable AddnSubVar : std_logic;
Variable ExtWordVar : std_logic;
Variable expectedY : std_logic_vector(N-1 downto 0);
Variable expectedZero : std_logic;
Variable expectedAltB : std_logic;
Variable expectedAltBu : std_logic;

variable LineBuffer : line;

Constant TestVectorFile : string := "ExecUnit01.tvs";
FILE 	 VectorFile : TEXT;

begin 
report "Using vector from file" & TestVectorFile;
FILE_OPEN (VectorFile, TestVectorFile, read_mode);
while not ENDFILE (VectorFile) loop 

	READLINE(VectorFile, LineBuffer);

	hread(LineBuffer, Avar);
	hread(LineBuffer, Bvar);
	read(LineBuffer, FuncClassVar);
	read(LineBuffer, LogicFNVar);
	read(LineBuffer, ShiftFNVar);
	read(LineBuffer, AddnSubVar);
	read(LineBuffer, ExtWordVar);
	hread(LineBuffer, expectedY);
	read(LineBuffer, expectedZero);
	read(LineBuffer, expectedAltB);
	read(LineBuffer, expectedAltBu);

-- assign the input to the signals 
inputA <= Avar;
inputB <= Bvar;
FuncClassIn <= FuncClassVar;
LogicFNIn <= LogicFNVar;
ShiftFNIn <= ShiftFNVar;
AddnSubIn <= AddnSubVar;
ExtWordIn <= ExtWordVar;
resultY <= expectedY;
ZeroIn <= expectedZero;
AltBIn <= expectedAltB;
AltBuIn <= expectedAltBu;
-- assign the signal ends 

--add delay
wait for 20 ns;
end loop;

--file close
Report "Simulation Completed";
File_close(VectorFile);
Wait;
--file close, end process next 
End process Main;
End architecture;