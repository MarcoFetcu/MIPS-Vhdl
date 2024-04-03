library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.std_logic_unsigned.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
   Port (
   clk : in  STD_LOGIC;
   inn: in STD_LOGIC;
   en: out  STD_LOGIC);    
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component InstructionFetch is
 Port ( 
           Clk : in STD_LOGIC;
           BranchAdress : in STD_LOGIC_VECTOR (15 downto 0);
           JumpAdress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PcSrc : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstruction : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component InstructionDecode is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (12 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end component;


component ControlUnit is
    Port ( Instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component InstructionExecute is
    Port ( NextInstruction : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           BranchAdress : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end component;

component DataMemory is
    Port ( clk: in std_logic;
           en: in std_logic;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal en: STD_LOGIC;
signal rst: STD_LOGIC;
signal RegWrite: STD_LOGIC;
signal RegDst: STD_LOGIC;
signal ExtOp: STD_LOGIC;
signal sa: STD_LOGIC;
signal Jump: STD_LOGIC;
signal ALUSrc: STD_LOGIC;
signal Branch: STD_LOGIC;
signal MemWrite: STD_LOGIC;
signal MemtoReg: STD_LOGIC;
signal Zero: STD_LOGIC;
signal PCSrc: STD_LOGIC;


signal do: STD_LOGIC_VECTOR (15 downto 0);
signal Instr: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal NextInstr: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal RD1: STD_LOGIC_VECTOR (15 downto 0);
signal RD2: STD_LOGIC_VECTOR (15 downto 0);
signal Ext_Imm: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal Ext_func: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal Ext_sa: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal BranchAdress: STD_LOGIC_VECTOR (15 downto 0);
signal BranchAdress2: STD_LOGIC_VECTOR (15 downto 0);
signal JumpAdress: STD_LOGIC_VECTOR (15 downto 0);
signal ALURes: STD_LOGIC_VECTOR (15 downto 0);
signal ALUResOut: STD_LOGIC_VECTOR (15 downto 0);
signal MemData: STD_LOGIC_VECTOR (15 downto 0);
signal WD: STD_LOGIC_VECTOR (15 downto 0);
signal func: STD_LOGIC_VECTOR (2 downto 0);
signal ALUOp: STD_LOGIC_VECTOR (2 downto 0);



begin
et1: MPG port map(clk,btn(0),en);
et2: MPG port map(clk,btn(1),rst);

IFetch: InstructionFetch port map(clk,BranchAdress,JumpAdress,Jump,PCSrc,en,rst,Instr,NextInstr);
IDecode: InstructionDecode port map(clk,en,Instr(12 downto 0),WD,RegWrite,RegDst,ExtOp,RD1,RD2,Ext_Imm,func,sa) ;
UControl: ControlUnit port map(Instr(15 downto 13),RegDst,ExtOp,ALUSrc,Branch,Jump,ALUOp,MemWrite,MemtoReg,RegWrite); 

IExecute: InstructionExecute port map(NextInstr,RD1,RD2,Ext_Imm,func,sa,ALUSrc,ALUOp,BranchAdress,ALURes,Zero);         
MData: DataMemory port map(clk,en,ALURes,RD2,MemWrite,MemData,ALUResOut);

--Suma: DataMemory port map(clk,'0',"0000000000001100",x"0000",'0',sum,nimic);
--Maxim: DataMemory port map(clk,'0',"0000000000001101",x"0000",'0',max,nimic);

--sum<=RD1+RD2;
--Ext_func(2 downto 0)<=func;
--Ext_sa(0)<=sa;


--WriteBack
with MemtoReg select
WD<= MemData when '1',
     ALUResOut when '0',
     (others =>'X') when others;
     
--Branch control     
PCSrc<=Zero and Branch;

--Jump adress
JumpAdress<=NextInstr(15 downto 13) & Instr(12 downto 0);


with sw(7 downto 5) select
    do<=    Instr when "000",
            NextInstr when "001",
            RD1 when "010",
            RD2 when "011",
            Ext_Imm when "100",
            ALURes when "101",
            MemData when "110",
            WD when "111",
            (others=>'X') when others;
            
            
et4: SSD port map(clk,do,an,cat);


led(10 downto 0)<=ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;


end Behavioral;

