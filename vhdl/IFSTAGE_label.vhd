library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFSTAGE_label is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE_label;

architecture Behavioral of IFSTAGE_label is

	COMPONENT PC_Register
	PORT (  
			  Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           WE : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0)
		  );
	END COMPONENT;
	
	COMPONENT Mux_2x1
	Port (  In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (31 downto 0)
		  );
	END COMPONENT;
			
signal signal_MuxOut: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal signal_PCout:  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal signal_Incrementor: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal signal_Immediate: STD_LOGIC_VECTOR(31 DOWNTO 0);


begin
	
	PC_Add: process(signal_PCout,PC_Immed)
	Begin
		signal_Incrementor <= signal_PCout + 4;
		signal_Immediate <=(signal_PCout + 4) + std_logic_vector(signed(PC_Immed) sll 2);

	End Process;

	PC_Reg: PC_Register
	PORT MAP (
					Clock => Clk,
					Reset => Reset,
					WE => PC_LdEn,
					Data => signal_MuxOut,
					Dout => signal_PCout
				);
				
	MUX: Mux_2x1
	PORT MAP (  
					In0 => signal_Incrementor,
					In1 => signal_Immediate,
					Sel => PC_Sel,
					Output => signal_MuxOut
				);
	PC <= signal_PCout;

end Behavioral;