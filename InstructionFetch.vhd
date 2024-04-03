library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;


entity InstructionFetch is
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
end InstructionFetch;

architecture Behavioral of InstructionFetch is

type Memorie is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM: Memorie := (

B"000_000_000_001_0_000", --X"0010" --ADD $1,$0,$0 --1
B"001_000_010_0000110", --X"2106" --ADDI $2,$0,6  --2
B"000_000_000_011_0_000", --X"0030" --ADD $3,$0,$0 --3
B"000_000_000_100_0_000", --X"0040" --ADD $4,$0,$0  --4
B"100_001_010_0000101", --X"8505" --BEQ $1,$2,5  --5
B"010_011_101_0000000", --X"4E80" --LW $5,Adr($3)  --6 --mod
B"000_100_101_100_0_000", --X"12C0" --ADD $4,$4,$5  --7
B"001_011_011_0000001", --X"2D81" --ADDI $3,$3,1  --8
B"001_001_001_0000001", --X"2481" --ADDI $1,$1,1  --9
B"111_0000000000100",  --X"E004" -- J 4  --10
B"011_000_100_0001100", --X"620C" -- SW $4,Adr(12)  --11

B"000_000_000_001_0_000", --X"0010" --ADD $1,$0,$0 --12
B"001_000_010_0000110", --X"2106" --ADDI $2,$0,6  --13
B"001_000_011_0000110", --X"2186" --ADDI $3,$0,6  --14
B"000_000_000_110_0_000", --X"0060" --ADD $6,$0,$0  --15
B"100_001_010_0000110", --X"8506" --BEQ $1,$2,6  --16
B"010_011_101_0000000", --X"4E80" --LW $5,Adr($3)  --17
B"110_110_101_0000001", --X"DA81" --BG $6,$5,1  --18
B"000_101_000_110_0_000", --X"1460" --ADD $6,$5,$0 --19
B"001_011_011_0000001", --X"2D81" --ADDI $3,$3,1  --20
B"001_001_001_0000001", --X"2481" --ADDI $1,$1,1  --21
B"111_0000000001111",  --X"E00F" -- J 15  --22
B"011_000_110_0001101", --X"630D" -- SW $6,Adr(13)  --23

B"010_000_010_0001100", --X"410C" --LW $2,Adr(12)  --24
B"010_000_011_0001101", --X"418d" --LW $3,Adr(13)  --25
B"000_010_011_000_0_001", --X"0981" --SUB $0,$2,$3 --26




others => x"0000");

signal PC: std_logic_vector(15 downto 0) := (others=> '0');

begin

process(clk,Reset,Enable,PcSrc,Jump)

begin

if rising_edge(clk) then 

 if Reset='1' then
    PC<=x"0000";
 else
     if Enable='1' then
             if Jump='1' then 
                PC<=JumpAdress;
             else
                    if PcSrc='1' then 
                        PC<=BranchAdress;
                    else
                         PC<=PC+1;
                    end if;
             end if;
        end if;
    end if;
end if;
end process;

Instruction<=ROM(conv_integer(PC));
NextInstruction<=PC+1;

end Behavioral;
