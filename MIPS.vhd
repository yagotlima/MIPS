LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity MIPS is
	port(
		clk, reset	: in  STD_LOGIC
	);
end entity;

architecture mips_arch of MIPS is

component cunit is
	port(
		CLK, RESET, ZERO				: in  STD_LOGIC;
		OP									: in  STD_LOGIC_VECTOR(5 downto 0);
		FUNCT								: in  STD_LOGIC_VECTOR(3 downto 0);
		REGWRITE, REGDST, IORD		: out STD_LOGIC;
		MEMREAD, MEMWRITE				: out STD_LOGIC;
		PCSOURCE							: out STD_LOGIC_VECTOR(1 downto 0);
		ALUCONTROL						: out STD_LOGIC_VECTOR(3 downto 0);
		ALUSRCB							: out STD_LOGIC_VECTOR(1 downto 0);
		ALUSRCA							: out STD_LOGIC;
		MEMTOREG, IRWRITE				: out STD_LOGIC;
		PCENABLE							: out STD_LOGIC
	);
end component;

component iunit is
	port(
		CLK, RESET								: in  STD_LOGIC;
		INSTRUCTION, ALURESULT, ALUOUT	: in  STD_LOGIC_VECTOR(31 downto 0);
		PCENABLE									: in  STD_LOGIC;
		PCSOURCE									: in  STD_LOGIC_VECTOR(1 downto 0);
		PC											: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component munit is
	port(
		CLK, RESET								: in  STD_LOGIC;
		PC, ALUOUT, WRITEDATA				: in  STD_LOGIC_VECTOR(31 downto 0);
		IORD, MEMREAD, MEMWRITE, IRWRITE	: in  STD_LOGIC;
		INSTRUCTION, MEMORYDATA				: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component eunit is
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

signal zero							: STD_LOGIC;
signal instruction, pc			: STD_LOGIC_VECTOR(31 downto 0);
signal aluresult, aluout		: STD_LOGIC_VECTOR(31 downto 0);
signal writedata, memorydata	: STD_LOGIC_VECTOR(31 downto 0);
signal regwrite, regdst, iord	: STD_LOGIC;
signal memread, memwrite		: STD_LOGIC;
signal pcsource					: STD_LOGIC_VECTOR(1 downto 0);
signal alucontrol					: STD_LOGIC_VECTOR(3 downto 0);
signal alusrcb						: STD_LOGIC_VECTOR(1 downto 0);
signal alusrca, memtoreg		: STD_LOGIC;
signal irwrite, pcenable		: STD_LOGIC;

begin

	unit1: cunit port map(CLK, RESET, zero, instruction(31 downto 26), instruction(3 downto 0), regwrite, regdst,
		iord, memread, memwrite, pcsource, alucontrol, alusrcb, alusrca, memtoreg, irwrite, pcenable);
	unit2: iunit port map(CLK, RESET, instruction, aluresult, aluout, pcenable, pcsource, pc);
	unit3: munit port map(CLK, RESET, pc, aluout, writedata, iord, memread, memwrite, irwrite, instruction, memorydata);
	unit4: eunit port map(CLK, RESET, instruction, memorydata, pc, regdst, memtoreg, regwrite, alusrca, alusrcb, 
		alucontrol, zero, aluresult, aluout, writedata);
	
end;
