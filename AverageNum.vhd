library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std;

entity Statistic is
	port(    clk      : in std_logic;
		 reset    : in std_logic;
		 en1      : in std_logic;
		 en2      : in std_logic;
		 en3      : in std_logic;
		 esum     : in std_logic;
		 enc      : in std_logic;
		 s2       : in std_logic;
		 s3       : in std_logic;
		 din      : in std_logic_vector(3 downto 0);
		 dout_mode: in std_logic_vector(1 downto 0);
		 gt1      : out std_logic;
		 gt2      : out std_logic;
		 gt3      : out std_logic;
		 zi       : out std_logic_vector(3 downto 0);
		 dout     : out std_logic_vector(3 downto 0));
end Statistic;

architecture Statistic_dataflow of Statistic is
		signal no_1 : std_logic_vector(3 downto 0);
		signal no_2 : std_logic_vector(3 downto 0);
		signal no_3 : std_logic_vector(3 downto 0);
		signal i    : std_logic_vector(3 downto 0);
		signal sum  : std_logic_vector(7 downto 0);
		signal avr  : std_logic_vector(3 downto 0);
	begin
		--fungsi Register no_1 untuk menentukan nilai output no_1
		process(clk,reset,en1)
		begin
			if (en1 = '1') then
				if (reset = '1') then
					no_1 <= (others => '0');
				elsif (clk'event and clk = '1') then
					no_1 <= din;
				end if;
			end if;
		end process;
		
		--fungsi input Register no_2 oleh selector s2 dan fungsi nilai output no_2
		process(clk,reset,en2)
		begin
			if (en2 = '1') then
				if (reset = '1') then
					no_2 <= (others => '0');
				elsif (clk'event and clk = '1') then
					if (s2 = '1') then   -- if disini berfungsi untuk menentukan nilai input register nomor 2 oleh selector s2
						no_2 <= din;
					elsif(s2 = '0') then
						no_2 <= no_1;
					end if;
				end if;
			end if;
		end process;	
		--fungsi input Register no_3 oleh selector s3 dan fungsi nilai output no_3
		process(clk,reset,en3)
		begin
			if (en3 = '1') then
				if (reset = '1') then
					no_3 <= (others => '0');
				elsif (clk'event and clk = '1') then
					if (s3 = '1') then -- if disini berfungsi untuk menentukan nilai input register nomor 2 oleh selector s2
						no_3 <= din;
					elsif(s3 = '0') then
						no_3 <= no_2;
					end if;
				end if;
			end if;
		end process;
		
		--fungsi komparator A>B
		gt1 <= '1' WHEN din > no_1 else '0';
		gt2 <= '1' WHEN din > no_2 else '0';
		gt3 <= '1' when din > no_3 else '0';
		
		--fungsi adder 
		sum <= sum+din;

		--fungsi register sum
		process (clk,reset,esum)
		begin
			if (esum = '1') then
				if (reset = '1') then
					sum <= (others => '0');
				elsif (clk'event and clk = '1') then
					sum <= sum;
				end if;
			end if;
		end process;
		--fungsi shift right
		avr <= '0' & sum(7 downto 5)  ;
		--fungsi multiplexer
		with dout_mode select
			dout <= avr when "00",
					no_1 when "01",
					no_2 when "10",
					no_3 when OTHERS;
		--fungsi register z1
		process(clk,reset,enc)
		begin
			if(enc = '1') then
				if (reset = '1') then
					i <= (others => '0');
				elsif (clk'event and clk = '1') then
					i <= "0010";    -- i bernilai 2 karena i=k-1 dan input(k) berjumlah 3
					
				end if;
			end if;
		end process;
		--assign i= k-1 pada zi
		zi<= i;
end Statistic_dataflow;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
