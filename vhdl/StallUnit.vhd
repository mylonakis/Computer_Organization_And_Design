library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity StallUnit is
    Port ( 
				OpCodeIDEX: in STD_LOGIC_VECTOR(5 downto 0);
				Rs_IFID : in  STD_LOGIC_VECTOR (4 downto 0);
				Rt_IFID : in  STD_LOGIC_VECTOR (4 downto 0);
				Rt_IDEX : in  STD_LOGIC_VECTOR (4 downto 0);
				Mux_sel : out  STD_LOGIC;
				IFID_WrEn : out  STD_LOGIC;
				Pc_LdEn_Out : out  STD_LOGIC);
end StallUnit;

architecture Behavioral of StallUnit is

signal temp0: STD_LOGIC;
signal temp1: STD_LOGIC;
signal temp2: STD_LOGIC;

begin
	process(OpCodeIDEX, Rs_IFID, Rt_IFID, Rt_IDEX)
	begin
		if(OpCodeIDEX = "000011" or OpCodeIDEX = "001111") then -- lb or lw probably need to put some bubbles
			if((Rt_IDEX = Rs_IFID) or (Rt_IDEX = Rt_IFID)) then -- Now will put the bubbles
				temp0 <= '1';
				temp1 <= '0';
				temp2 <= '0';
			else
				temp0 <= '0';
				temp1 <= '1';
				temp2 <= '1';
			end if;
		else
			temp0 <= '0';
			temp1 <= '1';
			temp2 <= '1';
		end if;
	end process;
	
	Mux_sel <= temp0;
	IFID_WrEn <= temp1;
	Pc_LdEn_Out <= temp2;

end Behavioral;

