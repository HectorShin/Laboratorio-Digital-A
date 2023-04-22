library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hamming is
    port(
    entrada: in std_logic_vector(11 downto 0);
    dados : out std_logic_vector(7 downto 0);  
    erro_int : out std_logic_vector(3 downto 0); 
    erro8_out: out std_logic;      
    erro7_out: out std_logic;     
    erro6_out: out std_logic;      
    erro5_out: out std_logic;      
    erro4_out: out std_logic;                
    erro3_out: out std_logic;     
    erro2_out: out std_logic;      
    erro1_out: out std_logic;      
    erro: out std_logic                       
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
    
    erro8_out <= erro8;
    erro7_out <= erro7;
    erro6_out <= erro6;
    erro5_out <= erro5;
    erro4_out <= erro4;
    erro3_out <= erro3;
    erro2_out <= erro2;
    erro1_out <= erro1;

    dados <= 
        (not dados_in(7)) & dados_in(6 downto 0) when (erro8 = '1') else
        dados_in(7) & (not dados_in(6)) & dados_in(5 downto 0) when (erro7 = '1') else
        dados_in(7 downto 6) & (not dados_in(5)) & dados_in(4 downto 0) when (erro6 = '1') else
        dados_in(7 downto 5) & (not dados_in(4)) & dados_in(3 downto 0) when (erro5 = '1') else
        dados_in(7 downto 4) & (not dados_in(3)) & dados_in(2 downto 0) when (erro4 = '1') else
        dados_in(7 downto 3) & (not dados_in(2)) & dados_in(1 downto 0) when (erro3 = '1') else
        dados_in(7 downto 2) & (not dados_in(1)) & dados_in(0) when (erro2 = '1') else
        dados_in(7 downto 1) & (not dados_in(0)) when (erro1 = '1');

    erro <= '1' when erro8 = '1' or erro7 = '1' or erro6 = '1' or erro5 = '1' or erro4 = '1'or erro3 = '1' or erro2 = '1' or erro1 = '1' else
            '0';
    end arch;
