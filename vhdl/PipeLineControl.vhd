library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PipeLineControl is
    Port ( 
			  OpCode : in STD_LOGIC_VECTOR(5 downto 0);	
           func : in STD_LOGIC_VECTOR(3 downto 0);
			  ZeroIn : in  STD_LOGIC;
			  --IFSTAGE
           PC_sel : out  STD_LOGIC;
--			  PC_LdEn: out STD_LOGIC;
			  --DECSTAGE
           RF_WrEn : out  STD_LOGIC;
           RF_WrData_sel : out  STD_LOGIC;
           RF_B_sel : out  STD_LOGIC;
			  ImmExt_s : out STD_LOGIC;
			  --ALUSTAGE
           ALU_RF_A_sel : out  STD_LOGIC;
           ALU_Bin_sel : out  STD_LOGIC;
           ALU_func : out  STD_LOGIC_VECTOR (3 downto 0);
			  --MEMSTAGE
			  --Need two flags instead of one like previous lab, because 
			  --there is probability to have different instructions in MEM and WB stage at the same time.
			  byteFlagMEM: out STD_LOGIC; --LSByte selector enable in MEMSTAGE for sb instruction
			  byteFlagWB: out STD_LOGIC;  --LSByte selector enable after MEMSTAGE, at WriteBack stage for lb instruction
           Mem_WrEn : out  STD_LOGIC
			  
			  --LAB 5
--			  IFID_WrEn: out STD_LOGIC;
--			  IDEX_WrEn: out STD_LOGIC;
--			  EXMEM_WrEn: out STD_LOGIC;
--			  MEMWB_WrEn: out STD_LOGIC
			  );
end PipeLineControl;

architecture Behavioral of PipeLineControl is
			
		
begin

	process(OpCode,func)
	begin
		if (OpCode = "100000") then --RTYPE
			PC_sel <='0';
			RF_B_sel <='0'; --rt
			RF_WrEn <='1';
			RF_WrData_sel <='0'; --ALU
			ALU_Bin_sel <='0';
			ALU_func <=func;
			Mem_WrEn <='0';
			ImmExt_s <='0';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		elsif (OpCode = "111000") then --li
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='1';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='1'; --Immed
			Mem_WrEn <='0';
			ImmExt_s <='1';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='1';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		elsif (OpCode = "111001") then --lui
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='1';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='1';
			ALU_func <="0000"; --add
			Mem_WrEn <='0';
			ImmExt_s <='0';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='1';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		elsif (OpCode = "110000") then --addi
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='1';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='1';
			ALU_func <="0000";
			Mem_WrEn <='0';
			ImmExt_s <='1';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		elsif (OpCode = "110010") then --nandi
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='1';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='1';
			ALU_func <="0010";
			Mem_WrEn <='0';
			ImmExt_s <='0'; --zerofill
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		elsif (OpCode = "110011") then --ori
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='1';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='1';
			ALU_func <="0011";
			Mem_WrEn <='0';
			ImmExt_s <='0';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		elsif (OpCode = "000011") then --lb
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='1';
			RF_WrData_sel <='1';
			ALU_Bin_sel <='1';
			ALU_func <="0000";
			Mem_WrEn <='0';
			ImmExt_s <='1';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='1';
		elsif (OpCode = "001111") then --lw
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='1';
			RF_WrData_sel <='1';
			ALU_Bin_sel <='1';
			ALU_func <="0000";
			Mem_WrEn <='0';
			ImmExt_s <='1';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		elsif (OpCode = "000111") then --sb
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='0';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='1';
			ALU_func <="0000";
			Mem_WrEn <='1';
			ImmExt_s <='0';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='1';
			byteFlagWB <='0';
		elsif (OpCode = "011111") then --sw
			PC_sel <='0';
			RF_B_sel <='1';
			RF_WrEn <='0';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='1';
			ALU_func <="0000";
			Mem_WrEn <='1';
			ImmExt_s <='0';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		else
			PC_sel <='0';
			RF_B_sel <='0';
			RF_WrEn <='0';
			RF_WrData_sel <='0';
			ALU_Bin_sel <='0';
			ALU_func <="0000";
			Mem_WrEn <='0';
			ImmExt_s <='0';
			--LAB 5 outputs
--			PC_LdEn <='1';
			ALU_RF_A_sel <='0';
			byteFlagMEM <='0';
			byteFlagWB <='0';
		end if;
	end process;
	
end Behavioral;