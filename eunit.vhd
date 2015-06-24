LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity eunit is
	port(
		CLK, RESET								: in  STD_LOGIC;
		INSTRUCTION, MEMORYDATA, PC		: in  STD_LOGIC_VECTOR(31 downto 0);
		REGDST, MEMTOREG, REGWRITE			: in  STD_LOGIC;
		ALUSRCA									: in  STD_LOGIC;
		ALUSRCB									: in  STD_LOGIC_VECTOR(1 downto 0);
		ALUCONTROL								: in  STD_LOGIC_VECTOR(3 downto 0);
		ZERO										: out STD_LOGIC;
		ALURESULT, ALUOUT, WRITEDATA		: out STD_LOGIC_VECTOR(31 downto 0)
	);
end entity;

architecture eunit_arch of eunit is

component ALU is
	
	GENERIC(width: integer := 32);
	PORT	(a,b: in std_logic_vector(width-1 downto 0);
			 sel:in std_logic_vector(3 downto 0);
			 saida: out std_logic_vector(width-1 downto 0));
end component;

component registers is
	port(
		CLK, RESET						: in  STD_LOGIC;
		REGWRITE							: in  STD_LOGIC;
		RDREGISTER1, RDREGISTER2	: in  STD_LOGIC_VECTOR(4 downto 0);
		WRREGISTER						: in  STD_LOGIC_VECTOR(4 downto 0);
		WRDATA							: in  STD_LOGIC_VECTOR(31 downto 0);
		RDDATA1, RDDATA2				: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component mux4 is
	generic(
		LARGURA	: natural := 1
	);

	port(
		a, b, c, d	: in  STD_LOGIC_VECTOR(LARGURA - 1 downto 0);
		sel			: in  STD_LOGIC_VECTOR(1 downto 0);
		q				: out STD_LOGIC_VECTOR(LARGURA - 1 downto 0)
	);
end component;

signal wrRegister						: STD_LOGIC_VECTOR(4 downto 0);
signal wrData							: STD_LOGIC_VECTOR(31 downto 0);
signal aluResultSig, aluOutSig	: STD_LOGIC_VECTOR(31 downto 0);
signal rdData1, rdData2				: STD_LOGIC_VECTOR(31 downto 0);
signal immed1, immed2				: STD_LOGIC_VECTOR(31 downto 0);
signal regA, regB						: STD_LOGIC_VECTOR(31 downto 0);
signal aluin1, aluin2				: STD_LOGIC_VECTOR(31 downto 0);

begin
	ALUOUT <= aluOutSig;
	ALURESULT <= aluResultSig;

	wrRegister	<= INSTRUCTION(20 downto 16) when REGDST = '0' else INSTRUCTION(15 downto 11);
	wrData		<= aluOutSig when MEMTOREG = '0' else MEMORYDATA;
	
	reg: registers port map(CLK, RESET, REGWRITE, INSTRUCTION(25 downto 21), INSTRUCTION(20 downto 16), wrRegister,
			wrData, rdData1, rdData2);

	immed1(15 downto 0)	<= INSTRUCTION(15 downto 0);
	immed1(31 downto 16) <= x"0000" when INSTRUCTION(15) = '0' else x"FFFF";
	
	immed2(1 downto 0)	<= "00";
	immed2(31 downto 2)	<= aluin1(29 downto 0);
	
	process(RESET, CLK, rdData1)
	begin
		if (RESET = '0') then
			regA <= x"00_00_00_00";
		elsif rising_edge(CLK) then
			regA <= rdData1;
		end if;
	end process;
	
	process(RESET, CLK, rdData2)
	begin
		if (RESET = '0') then
			regB <= x"00_00_00_00";
		elsif rising_edge(CLK) then
			regB <= rdData2;
		end if;
	end process;
	
	aluin1 <= PC when ALUSRCA = '0' else regA;
	
	mux1: mux4 generic map(32) port map(regB, x"00_00_00_04", immed1, immed2, ALUSRCB, aluin2);
	alu1: alu generic map(32) port map(aluin1, aluin2, ALUCONTROL, aluResultSig);
	
	process(RESET, CLK, aluResultSig)
	begin
		if (RESET = '0') then
			aluOutSig <= x"00_00_00_00";
		elsif rising_edge(CLK) then
			aluOutSig <= aluResultSig;
		end if;
	end process;
		
end;
