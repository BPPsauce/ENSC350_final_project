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
	
	begin
	
	Y <= result;
	with extWord select
	 ShiftCountSig <= unsigned(B(5 downto 0)) when '0',
												 unsigned ('0' & B(4 downto 0)) when '1',
												unsigned(B(5 downto 0)) when others;

	--select for input A
	isSwapWord <= ShiftFN(1) AND ExtWord;
	with isSwapWord select
	inputToBS <= A when '0',
										A(31 downto 0) & A(63 downto 32) when '1',
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
	

	process (ShiftFN, ExtWord) is 
	begin 
	if (shiftFN(0) = '1') then 
	CorSLL <= SLLout;
	SRLorSRA <= SRAout;
	else 
	CorSLL <= C;
	SRLorSRA <= SRLout;
	end if;
	
	if (ExtWord = '1') then 
	CorSLL <= std_logic_vector(resize(signed(CorSLL(N-33 downto 0)), CorSLL'length));
	SRLorSRA <= std_logic_vector(resize(signed(SRLorSRA (N-1 downto 32)), SRLorSRA'length));
	end if;
	end process;
	
	with ShiftFN(1) select
	result <= SRLorSRA when '1',
							CorSLL when others;
	
end bhv; 