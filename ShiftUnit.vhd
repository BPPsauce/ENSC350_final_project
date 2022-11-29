library IEEE;
use IEEE.STD_LOGIC_1164.all;
Use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

Entity ShiftUnit is
	Generic ( N : natural := 64 );
	Port ( A, B, C : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftFN : in std_logic_vector( 1 downto 0 );
					ExtWord : in std_logic );
End Entity ShiftUnit;

architecture bhv of ShiftUnit is
--component starts
	component SLL64 is
		Generic ( N : natural := 64 );
		Port ( X : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
	end component;
	
	component SRL64 is
		Generic ( N : natural := 64 );
		Port ( X : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
	end component;	
	
	component SRA64 is
		Generic ( N : natural := 64 );
		Port ( X : in std_logic_vector( N-1 downto 0 );
					Y : out std_logic_vector( N-1 downto 0 );
					ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
	end component;	
--component ends	

	signal result : std_logic_vector (N-1 downto 0);
	--signal signExtend : signed (N-1 downto 0); --32 bit sign extened 
	signal ShiftCountSig : unsigned (integer(ceil(log2(real(N))))-1 downto 0 );
	signal inputToBS: std_logic_vector(N -1 downto 0);
	signal isSwapWord : std_logic;
	signal SLLout : std_logic_vector(N-1 downto 0);
	signal SRLout : std_logic_vector(N-1 downto 0);
	signal SRAout : std_logic_vector(N-1 downto 0);
	signal CorSLL : std_logic_vector (N-1 downto 0);
	signal SRLorSRA : std_logic_vector (N-1 downto 0);
	signal Flag : std_logic_vector (1 downto 0);
	signal CorSLLout : std_logic_vector (N-1 downto 0);
	signal SRLorSRAout : std_logic_vector (N-1 downto 0);
	signal swapped  : std_logic_vector (N-1 downto 0);
	
	begin
	Y <= result;
	with ExtWord select
	 ShiftCountSig <= unsigned(B(5 downto 0)) when '0',
												 unsigned ('0' & B(4 downto 0)) when '1',
												unsigned(B(5 downto 0)) when others;

	--select for input A
	isSwapWord <= ShiftFN(1) AND ExtWord;
	swapped <= A(31 downto 0) & A(N-1 downto 32) ;
	
	with isSwapWord select
	inputToBS <= A when '0',
										swapped when '1',
										A when others;
	
	-- mapping for the barrel shifters
	SLLunit : SLL64
	generic map (64)
	port map (X => inputToBS, Y => SLLout, ShiftCount => ShiftCountSig);
	
	SRLunit : SRL64
	generic map (64)
	port map (X => inputToBS, Y => SRLout, ShiftCount => ShiftCountSig);
	
	SRAunit : SRA64
	generic map (64)
	port map (X => inputToBS, Y => SRAout, ShiftCount => ShiftCountSig);
	-- end of mapping for the barrel shifters
	
	with ShiftFN(0) select
	CorSLLout <= SLLout when '1',
									C when '0',
							  C when others;
	
	with ShiftFN(0) select
	SRLorSRAout <= SRAout when '1',
										SRLout when '0',
									  SRLout when others;
	
	with ExtWord select
	CorSLL <= std_logic_vector(resize(signed(CorSLLout(N-33 downto 0)), CorSLL'length)) when '1', --31 to 0
								CorSLLout when '0',
							  CorSLLout when others;
	
	with ExtWord select
	SRLorSRA <= std_logic_vector(resize(signed(SRLorSRAout (N-1 downto 32)), SRLorSRA'length)) when '1', -- 63 to 32
									  SRLorSRAout when '0',
		                       SRLorSRAout when others;
	
	with ShiftFN(1) select
	result <= SRLorSRA when '1',
							CorSLL when '0',
							CorSLL when others;
							
end bhv; 