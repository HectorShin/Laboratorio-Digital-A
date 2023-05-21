-- registrador
library ieee;
use ieee.std_logic_1164.all;

entity reg is
    generic (
        tamanho : integer := 48
    );
    port (
        clock: in std_logic;
        reset: in std_logic;
        load: in std_logic;
        d: in std_logic_vector(tamanho-1 downto 0);
        q: out std_logic_vector(tamanho-1 downto 0)
    );
end reg;

architecture reg_arch of reg is
begin
    behavior: process(clock, reset)
    begin
        if (reset='1') then
            q <= (others => '0');
        elsif (load='1') then
            if (clock'event) and (clock='1') then
                q <= d;
            end if;
        end if;
    end process;
end architecture;

-- Lucas Rodrigues Giacone
-- 11831901 Quarta Bancada B5

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity down_counter is
	generic(
		wIDTH: integer := 4
	);
	port(
		clk : in  std_logic;
		en	 : in  std_logic;
		load: in  std_logic;
		D	 : in  std_logic_vector(wIDTH-1 downto 0);
		Q	 : out std_logic_vector(wIDTH-1 downto 0);
		RCO : out std_logic
	);
end entity down_counter;

architecture behaviorial of down_counter is
	signal count : unsigned(WIDTH-1 downto 0);
begin
	process(clk, en, load)
	begin
		if load = '1' then
			count <= unsigned(D);
		elsif rising_edge(clk) and en = '1' then
			count <= count - 1;
		end if;
	end process;
	Q <= std_logic_vector(count);
	RCO <= '1' when count = 0 else '0';

end architecture behaviorial;

-- manchester
library ieee;
use ieee.std_logic_1164.all;

entity manchester is
    port (
        data_in : in std_logic;
        clk : in std_logic
        data_out : out std_logic;
    );
end entity;

architecture manchester_arch of manchester is
    signal clk_out : std_logic;
    signal ff_out : std_logic;
    signal rco : std_logic
    signal en : std_logic;
    signal q : std_logic_vector(3 downto 0);
    component down_counter is
        generic(
		    wIDTH: integer := 4
        );
        port(
            clk : in  std_logic;
            en	 : in  std_logic;
            load: in  std_logic;
            D	 : in  std_logic_vector(wIDTH-1 downto 0);
            Q	 : out std_logic_vector(wIDTH-1 downto 0);
            RCO : out std_logic
        );
    end component;
    begin
        clk_out <= data_in xor ff_out;
        data_out <= ff_out;
        en <= clk_out or not(q3);

        counter : down_counter generic map(4) port map(clk, en, rco, "1100", q, rco)

        process(rco, data_in, ff_out)
        begin
            if rco'event and rco = '1' then
                ff_out <= data_in;
            end if;
        end process;
        
    end architecture;

-- VHDL do Receptor Serial modo 8E2
-- Lucas Rodrigues Giacone
-- Nusp: 11831901

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx is
   generic (baudrate : integer := 384);
   port (
       clock : in std_logic; --Entrar com o clock de 50MHz do FPGA
       reset : in std_logic; --Reset, Lembre q o FPGA é active low, se aperta o botao o reset vai para 0
       data_in : in std_logic; --Entrada da antena
       dado : out std_logic_vector(11 downto 0); --Saida do receptor
       paridade : out std_logic; --Saida da paridade
       fim : out std_logic --Sinal de controle da saida, So ler o valor de dado quando este sinal estiver em 1
   );
end rx;

architecture exemplo of rx is
    component manchester is
        port (
            data_in : in std_logic;
            clk : in std_logic
            data_out : out std_logic;
        );
    end component;
   function xor_reduce(input_vector : in std_logic_vector; r_start : in integer; r_end : in integer) return std_logic is
       variable result : std_logic;
       begin
           result := input_vector(r_start);
           for i in r_start + 1 to r_end loop
            result := result xor input_vector(i);
           end loop;
           return result;
   end function;

   signal clockdiv : std_logic;
   signal IQ : unsigned(25 downto 0);
   signal IQ2 : unsigned(3 downto 0);
   signal buff : std_logic_vector(12 downto 0);
   signal tick : std_logic;
   signal encount : std_logic;
   signal resetcount : std_logic;
   signal sin : std_logic;

   type tipo_estado is (inicial, sb, p1, p2, d0, p4, d1, d2, d3, p8, d4, d5, d6, d7, pb, final);
   signal estado : tipo_estado;

   begin
    manch : manchester port map(data_in, clockdiv, sin)
   -- ===========================
   -- Divisor de clock
   -- ===========================
   process (clock, reset, IQ, clockdiv)
   begin
       if reset = '1' then
           IQ <= (others => '0');
       elsif clock'event and clock = '1' then
           if IQ = 50000000/(baudrate * 16 * 2) then
               clockdiv <= not(clockdiv);
               IQ <= (others => '0');
           else
               IQ <= IQ + 1;
           end if;
       end if;
   end process;

   -- ===========================
   -- Superamostragem 16x
   -- ===========================		
   process (clockdiv, resetcount, encount)
   begin
       if resetcount = '1' then
           IQ2 <= (others => '0');
       elsif clockdiv'event and clockdiv = '1' and encount = '1' then
           IQ2 <= IQ2 + 1;
       end if;
   end process;

   tick <= '1' when IQ2 = 8 else '0';

   -- ===========================
   -- Maquina de Estados do Transmissor
   -- ===========================
   process (clockdiv, reset, sin, tick, estado)
   begin
       if reset = '1' then
           estado <= inicial;
       elsif clockdiv'event and clockdiv = '1' then
           case estado is

               when inicial => 
                   if sin = '0' then 
                       estado <= sb;
                   else 
                       estado <= inicial;
                   end if;

               when sb => 
                   if tick = '1' then 
                       estado <= p1;
                   else 
                       estado <= sb;
                   end if;
                   buff <= (others => '0');

                when p1 => 
                   if tick = '1' then
                       estado <= p2;
                       buff(0) <= sin;
                   else 
                       estado <= p1;
                   end if;

                when p2 => 
                   if tick = '1' then
                       estado <= d0;
                       buff(1) <= sin;
                   else 
                       estado <= p2;
                   end if;

               when d0 => 
                   if tick = '1' then
                       estado <= p4;
                       buff(2) <= sin;
                   else 
                       estado <= d0;
                   end if;

                when p4 => 
                   if tick = '1' then
                       estado <= d1;
                       buff(3) <= sin;
                   else 
                       estado <= p4;
                   end if;

               when d1 => 
                   if tick = '1' then
                       estado <= d2;
                       buff(4) <= sin;
                   else 
                       estado <= d1;
                   end if;

               when d2 => 
                   if tick = '1' then
                       estado <= d3;
                       buff(5) <= sin;
                   else 
                       estado <= d2;
                   end if;

               when d3 => 
                   if tick = '1' then
                       estado <= p8;
                       buff(6) <= sin;
                   else   
                       estado <= d3;
                   end if;

                when p8 => 
                   if tick = '1' then
                       estado <= d4;
                       buff(7) <= sin;
                   else 
                       estado <= p8;
                   end if;

               when d4 =>
                   if tick = '1' then
                       estado <= d5;
                       buff(8) <= sin;
                   else
                       estado <= d4;
                   end if;

               when d5 => 
                   if tick = '1' then
                       estado <= d6;
                       buff(9) <= sin;
                   else 
                       estado <= d5;
                   end if;

               when d6 => 
                   if tick = '1' then
                       estado <= d7;
                       buff(10) <= sin;
                   else 
                       estado <= d6;
                   end if;

               when d7 => 
                   if tick = '1' then
                       estado <= pb;
                       buff(11) <= sin;
                   else
                       estado <= d7;
                   end if;

                when pb => 
                   if tick = '1' then
                       estado <= final;
                       buff(12) <= sin;
                       paridade <= xor_reduce(buff(12 downto 8) & buff(6 downto 4) & buff(2), 0, 8);
                   else 
                       estado <= pb;
                   end if;

               when final => 
                   if tick = '1' then
                       estado <= inicial;
                   else 
                       estado <= final;
                   end if;

               when others => 
                   estado <= inicial;
           end case;
       end if;
   end process;

   with estado select encount <=
   '0' when inicial,
   '1' when others;

   with estado select resetcount <=
   '1' when inicial,
   '0' when others;

   -- ===========================
   -- Logica de saida
   -- ===========================
   with estado select fim <=
   '1' when final,
   '0' when others;

   dado <= buff(11 downto 0);
   
end exemplo;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity projeto is
   port(
        dado_in : in std_logic_vector(7 downto 0); --Dados de saida do RX
        clock_in : in std_logic; --Fim do RX
        dado_out : out std_logic_vector(47 downto 0); -- Saida com capacidade de 6 caracteres
		  led : out std_logic
   );
end projeto;

architecture arch of projeto is

	 signal led_in : std_logic := '0';
    signal contador_caractere : integer range 0 to 6 := 6;
    signal buffo : std_logic_vector(47 downto 0):= (others => '0');
	 --signal vetor_caracteres : std_logic_vector(47 downto 0) := (others => '0');

   type tipo_caractere is (del, cr, normal);
   signal estado_caractere : tipo_caractere := normal;

   component reg is
        generic(
            tamanho: integer := 48
        );
       port (
           clock: in std_logic;
           reset: in std_logic;
           load: in std_logic;
           d: in std_logic_vector(tamanho-1 downto 0);
           q: out std_logic_vector(tamanho-1 downto 0)
       );
   end component;

   begin
       --reg_a: reg generic map(48) port map(clock_in, '0', '1', buffo, vetor_caracteres);

       process(dado_in, clock_in)
       begin
           if clock_in'event and clock_in = '1' then
               case estado_caractere is
                    when normal =>
                        if dado_in > "00011111" and dado_in < "01111111" then
                            buffo <= buffo(39 downto 0) & dado_in;
                            estado_caractere <= normal;
                        end if;
                        if dado_in = "01111111" then
                            buffo(7 downto 0) <= "00100000";
									 estado_caractere <= del;
                        end if;
                        if dado_in = "00001101" then -- CR
                            estado_caractere <= cr;
                        end if;
                        if dado_in = "00001010" then -- LF
                            buffo <= (others => '0');
									 estado_caractere <= cr;
                        end if;
                        if dado_in = "00010110" then
                            led_in <= not(led_in);
                            --estado_caractere <= normal;
                        end if;
                    when del =>
                        if dado_in > "00011111" and dado_in < "01111111" then
                            buffo(7 downto 0) <= dado_in;
                            estado_caractere <= normal;
                        end if;
                    when cr =>
                        if dado_in > "00011111" and dado_in < "01111111" and contador_caractere > 1 then
                            buffo(contador_caractere*8-1 downto contador_caractere*8-8) <= dado_in;
									 contador_caractere <= contador_caractere - 1;
                            estado_caractere <= cr;
                        else
									if dado_in > "00011111" and dado_in < "01111111" and contador_caractere = 1 then
										buffo(7 downto 0) <= dado_in;
										contador_caractere <= 6;
										estado_caractere <= normal;
									end if;
                        end if;
                    when others =>
                        estado_caractere <= normal;
               end case;
               dado_out <= buffo;
					led <= led_in;
           end if;
       end process;
end architecture;

-- display
library ieee;
use ieee.std_logic_1164.all;

entity display is
   port (
       input : in std_logic_vector(7 downto 0); -- ASCII 8 bits
       output : out std_logic_vector(7 downto 0) -- ponto + abcdefg
   );
end display;

architecture comb of display is
begin
   with input select output <=
       "00000000" when "00100000", -- (space)
       "10000110" when "00100001", -- ! 
       "00100010" when "00100010", -- " 
       "01111110" when "00100011", -- # 
       "01101101" when "00100100", -- $ 
       "11010010" when "00100101", -- % 
       "01000110" when "00100110", -- & 
       "00100000" when "00100111", -- ' 
       "00101001" when "00101000", -- ( 
       "00001011" when "00101001", -- ) 
       "00100001" when "00101010", -- * 
       "01110000" when "00101011", -- + 
       "00010000" when "00101100", -- ,
       "01000000" when "00101101", -- - 
       "10000000" when "00101110", -- . 
       "01010010" when "00101111", -- / 
       "00111111" when "00110000", -- 0 
       "00000110" when "00110001", -- 1 
       "01011011" when "00110010", -- 2 
       "01001111" when "00110011", -- 3 
       "01100110" when "00110100", -- 4 
       "01101101" when "00110101", -- 5 
       "01111101" when "00110110", -- 6 
       "00000111" when "00110111", -- 7 
       "01111111" when "00111000", -- 8 
       "01101111" when "00111001", -- 9 
       "00001001" when "00111010", -- : 
       "00001101" when "00111011", -- ; 
       "01100001" when "00111100", -- < 
       "01001000" when "00111101", -- = 
       "01000011" when "00111110", -- > 
       "11010011" when "00111111", -- ? 
       "01011111" when "01000000", -- @ 
       "01110111" when "01000001", -- A 
       "01111100" when "01000010", -- B 
       "00111001" when "01000011", -- C 
       "01011110" when "01000100", -- D 
       "01111001" when "01000101", -- E 
       "01110001" when "01000110", -- F 
       "00111101" when "01000111", -- G 
       "01110110" when "01001000", -- H 
       "00110000" when "01001001", -- I 
       "00011110" when "01001010", -- J 
       "01110101" when "01001011", -- K 
       "00111000" when "01001100", -- L 
       "00010101" when "01001101", -- M 
       "00110111" when "01001110", -- N 
       "00111111" when "01001111", -- O 
       "01110011" when "01010000", -- P 
       "01101011" when "01010001", -- Q 
       "00110011" when "01010010", -- R 
       "01101101" when "01010011", -- S 
       "01111000" when "01010100", -- T 
       "00111110" when "01010101", -- U 
       "00111110" when "01010110", -- V 
       "00101010" when "01010111", -- W 
       "01110110" when "01011000", -- X 
       "01101110" when "01011001", -- Y 
       "01011011" when "01011010", -- Z 
       "00111001" when "01011011", -- [ 
       "01100100" when "01011100", -- \ 
       "00001111" when "01011101", -- ] 
       "00100011" when "01011110", -- ^ 
       "00001000" when "01011111", -- _ 
       "00000010" when "01100000", -- ` 
       "01011111" when "01100001", -- a 
       "01111100" when "01100010", -- b 
       "01011000" when "01100011", -- c 
       "01011110" when "01100100", -- d 
       "01111011" when "01100101", -- e 
       "01110001" when "01100110", -- f 
       "01101111" when "01100111", -- g 
       "01110100" when "01101000", -- h 
       "00010000" when "01101001", -- i 
       "00001100" when "01101010", -- j 
       "01110101" when "01101011", -- k 
       "00110000" when "01101100", -- l 
       "00010100" when "01101101", -- m 
       "01010100" when "01101110", -- n 
       "01011100" when "01101111", -- o 
       "01110011" when "01110000", -- p 
       "01100111" when "01110001", -- q 
       "01010000" when "01110010", -- r 
       "01101101" when "01110011", -- s 
       "01111000" when "01110100", -- t 
       "00011100" when "01110101", -- u 
       "00011100" when "01110110", -- v 
       "00010100" when "01110111", -- w 
       "01110110" when "01111000", -- x 
       "01101110" when "01111001", -- y 
       "01011011" when "01111010", -- z 
       "01000110" when "01111011", -- { 
       "00110000" when "01111100", -- | 
       "01110000" when "01111101", -- } 
       "00000001" when "01111110", -- ~ 
       "00000000" when "01111111", -- (del) 
       "00000000" when others;

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hamming is
    port(
    entrada: in std_logic_vector(11 downto 0);
    dados : out std_logic_vector(7 downto 0);  
    erro_int : out std_logic_vector(3 downto 0)                      
    );
end hamming;

architecture arch of hamming is

    signal p8, p4, p2, p1 : std_logic;
    signal paridade : std_logic_vector(3 downto 0);
    signal dados_in : std_logic_vector(7 downto 0);
	 signal erro8, erro7, erro6, erro5, erro4, erro3, erro2, erro1 : std_logic;

begin
    dados_in <= entrada(11 downto 8) & entrada(6 downto 4) & entrada(2);
    paridade <= entrada(7) & entrada(3) & entrada(1) & entrada(0);

    p8 <= dados_in(7) xor dados_in(6) xor dados_in(5) xor dados_in(4) xor paridade(3);
    p4 <= dados_in(7) xor dados_in(3) xor dados_in(2) xor dados_in(1) xor paridade(2);
    p2 <= dados_in(6) xor dados_in(5) xor dados_in(3) xor dados_in(2) xor dados_in(0) xor paridade(1);
    p1 <= dados_in(6) xor dados_in(4) xor dados_in(3) xor dados_in(1) xor dados_in(0) xor paridade(0);

    erro_int <= p8 & p4 & p2 & p1;

    erro8 <=  p8 and p4 and (not p2) and (not p1);
    erro7 <=  p8 and (not p4) and p2 and p1;
    erro6 <=  p8 and (not p4) and p2 and (not p1);
    erro5 <=  p8 and (not p4) and (not p2) and p1;
    erro4 <= (not p8) and p4 and p2 and p1;
    erro3 <= (not p8) and p4 and p2 and (not p1);
    erro2 <= (not p8) and p4 and (not p2) and p1;
    erro1 <= (not p8) and (not p4) and p2 and p1;

    dados <= 
        (not dados_in(7)) & dados_in(6 downto 0) when (erro8 = '1') else
        dados_in(7) & (not dados_in(6)) & dados_in(5 downto 0) when (erro7 = '1') else
        dados_in(7 downto 6) & (not dados_in(5)) & dados_in(4 downto 0) when (erro6 = '1') else
        dados_in(7 downto 5) & (not dados_in(4)) & dados_in(3 downto 0) when (erro5 = '1') else
        dados_in(7 downto 4) & (not dados_in(3)) & dados_in(2 downto 0) when (erro4 = '1') else
        dados_in(7 downto 3) & (not dados_in(2)) & dados_in(1 downto 0) when (erro3 = '1') else
        dados_in(7 downto 2) & (not dados_in(1)) & dados_in(0) when (erro2 = '1') else
        dados_in(7 downto 1) & (not dados_in(0)) when (erro1 = '1') else
		  dados_in;

    end arch;

    
