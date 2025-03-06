library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           DataToRam : out  STD_LOGIC_VECTOR (31 downto 0); -- lab 5 new Signal
           ALU_result : in  STD_LOGIC_VECTOR (31 downto 0);--lab 5
           DataIn_WB : in  STD_LOGIC_VECTOR (31 downto 0); --lab 5
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
			  ALU_RF_A_sel: in STD_LOGIC;
           ALU_Bin_sel : in  STD_LOGIC;
           ForwardA : in  STD_LOGIC_VECTOR(1 downto 0);
           ForwardB : in  STD_LOGIC_VECTOR(1 downto 0);
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  ZERO : out STD_LOGIC
			  );
end ALUSTAGE;

architecture Behavioral of ALUSTAGE is

Component ALU
Port (     A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           OP : in  STD_LOGIC_VECTOR (3 downto 0);
           COUT : out  STD_LOGIC;
           ZERO : out  STD_LOGIC;
           OVF : out  STD_LOGIC;
           AOUT : out  STD_LOGIC_VECTOR (31 downto 0));
			  
end component;

signal cout, sigzero , ovf :std_logic;

signal mux_A_out : std_logic_vector(31 downto 0);
signal temp_mux_A_out : std_logic_vector(31 downto 0);

signal mux_out_to_A : std_logic_vector(31 downto 0); --lab 5
signal temp_mux_out_to_A : std_logic_vector(31 downto 0); --lab 5

signal mux_out_ForwardB : std_logic_vector(31 downto 0); --lab 5
signal temp_mux_out_ForwardB : std_logic_vector(31 downto 0); --lab 5

signal mux_out_to_B : std_logic_vector(31 downto 0); --lab 5
signal temp_mux_out_to_B : std_logic_vector(31 downto 0); --lab 5

begin
   ALU_Inst : ALU PORT MAP(
	A => mux_out_to_A,
	B => mux_out_to_B,
	OP => ALU_func,
	COUT => cout,
	ZERO => sigzero,
	OVF => ovf,
	AOUT => ALU_out
);
------------------- FOR A INPUT -----------------------------------
Mux_A: process (RF_A, ALU_RF_A_sel) -- For LI and LUI instructions
begin
		if ALU_RF_A_sel = '0' then temp_mux_A_out <= RF_A;
		else temp_mux_A_out <= "00000000000000000000000000000000";
		end if;
end process;

mux_A_out <= temp_mux_A_out;

Mux_ForwardA: process(mux_A_out, ALU_result, DataIn_WB, ForwardA) -- lab 5
begin
	if (ForwardA = "01") then temp_mux_out_to_A <= ALU_result after 5 ns;
	elsif(ForwardA = "10") then temp_mux_out_to_A <= DataIn_WB after 5 ns;
	else temp_mux_out_to_A <= mux_A_out after 5 ns;
	end if;
end process;

mux_out_to_A <= temp_mux_out_to_A;
------------------- FOR B INPUT -----------------------------------

Mux_ForwardB: process(RF_B, ALU_result, DataIn_WB, ForwardB) -- lab 5
begin
	if (ForwardB = "01") then temp_mux_out_ForwardB <= ALU_result after 5 ns;
	elsif(ForwardB = "10") then temp_mux_out_ForwardB <= DataIn_WB after 5 ns;
	else temp_mux_out_ForwardB <= RF_B after 5 ns;
	end if;
end process;

mux_out_ForwardB <= temp_mux_out_ForwardB;

Mux_B: process (mux_out_ForwardB, Immed, ALU_Bin_sel)
begin
		if ALU_Bin_sel = '0' then temp_mux_out_to_B <= mux_out_ForwardB;
		else temp_mux_out_to_B <= Immed;
		end if;
end process;

mux_out_to_B <= temp_mux_out_to_B;
DataToRam <= mux_out_ForwardB;        -- to shma pou mpainei sthn eisodo B tis alu to exoume kai ws eksodo sto decstage
												  -- xreiazetai gia na mporw na kanw forward otan exw entoles sb kai sw
												  -- dioti ayto 8a to dinw twra ws dataIn sthn mnhmh anti to RF_B apo to decstage
ZERO <= sigzero;

end Behavioral;

