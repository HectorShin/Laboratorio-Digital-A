library IEEE;
use IEEE.numeric_bit.all;

entity tb is
    
end tb;    

architecture behavioral of tb is 

component hamming 
    port(
    entrada : in  bit_vector(28 downto 0); 
    dados   : out bit_vector(23 downto 0);
    erro    : out bit);
end component;

signal entrada : bit_vector(28 downto 0);
signal dados   : bit_vector(23 downto 0);
signal erro    : bit;

begin
    DUT: hamming port map(entrada => entrada, dados => dados, erro => erro);
    
    process
    begin
        --        23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
        -- Dados: "1  0  1  0  0  0  1  0  0  1  0  0  1  1  1  0  1  0  1  0  1  1  1  0"
        -- P5 (D23 downto D11)                                                    : 1
        -- P4 (D23 downto D18) e (D10 downto D04)                                 : 0
        -- P3 (D23, D22, D17 downto D14, D10 downto D7, D3, D2 e D1 )             : 1
        -- P2 (D21, D20, D17, D16, D13, D12, D10, D09, D06, D05, D03, D02 e D00)  : 1
        -- P1 (Alternando D00, D02, D04...)                                       : 1
        
        entrada <= "10100010010011101010111010111"; -- Dados e paridade corretos
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando todos os bits estao corretos" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando todos os bits estão corretos" severity error; 
        
        entrada <= "00100010010011101010111010111"; -- Entrada(28) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(28) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(28) esta errado" severity error; 

        entrada <= "11100010010011101010111010111"; -- Entrada(27) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(27) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(27) esta errado" severity error; 

        entrada <= "10000010010011101010111010111"; -- Entrada(26) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(26) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(26) esta errado" severity error;
        
        entrada <= "10110010010011101010111010111"; -- Entrada(25) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(25) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(25) esta errado" severity error;
        
        entrada <= "10101010010011101010111010111"; -- Entrada(24) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(24) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(24) esta errado" severity error;
        
        entrada <= "10100110010011101010111010111"; -- Entrada(23) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(23) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(23) esta errado" severity error;
        
        entrada <= "10100000010011101010111010111"; -- Entrada(22) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(22) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(22) esta errado" severity error;
        
        entrada <= "10100011010011101010111010111"; -- Entrada(21) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(21) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(21) esta errado" severity error;
        
        entrada <= "10100010110011101010111010111"; -- Entrada(20) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(20) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(20) esta errado" severity error;
        
        entrada <= "10100010000011101010111010111"; -- Entrada(19) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(19) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(19) esta errado" severity error; 

        entrada <= "10100010011011101010111010111"; -- Entrada(18) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(18) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(18) esta errado" severity error; 

        entrada <= "10100010010111101010111010111"; -- Entrada(17) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(17) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(17) esta errado" severity error;
        
        entrada <= "10100010010001101010111010111"; -- Entrada(16) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(16) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(16) esta errado" severity error; 

        entrada <= "10100010010010101010111010111"; -- Entrada(15) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(15) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(15) esta errado" severity error;
        
        entrada <= "10100010010011001010111010111"; -- Entrada(14) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(14) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(14) esta errado" severity error; 

        entrada <= "10100010010011111010111010111"; -- Entrada(13) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(13) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(13) esta errado" severity error; 

        entrada <= "10100010010011100010111010111"; -- Entrada(12) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(12) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(12) esta errado" severity error; 

        entrada <= "10100010010011101110111010111"; -- Entrada(11) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(11) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(11) esta errado" severity error; 

        entrada <= "10100010010011101000111010111"; -- Entrada(10) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(10) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(10) esta errado" severity error; 

        entrada <= "10100010010011101011111010111"; -- Entrada(9) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(9) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(9) esta errado" severity error; 

        entrada <= "10100010010011101010011010111"; -- Entrada(8) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(8) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(8) esta errado" severity error; 

        entrada <= "10100010010011101010101010111"; -- Entrada(7) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(7) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(7) esta errado" severity error; 

        entrada <= "10100010010011101010110010111"; -- Entrada(6) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(6) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(6) esta errado" severity error; 

        entrada <= "10100010010011101010111110111"; -- Entrada(5) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(5) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(5) esta errado" severity error; 

        entrada <= "10100010010011101010111000111"; -- Entrada(4) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(4) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(4) esta errado" severity error; 

        entrada <= "10100010010011101010111011111"; -- Entrada(3) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(3) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(3) esta errado" severity error; 

        entrada <= "10100010010011101010111010011"; -- Entrada(2) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(2) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(2) esta errado" severity error; 

        entrada <= "10100010010011101010111010101"; -- Entrada(1) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(1) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(1) esta errado" severity error; 

        entrada <= "10100010010011101010111010110"; -- Entrada(0) errado
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando somente o bit entrada(0) esta errado" severity error;
        assert(erro = '0') report "ghdlfiddle:BAD Falha em 'erro' quando somente o bit entrada(0) esta errado" severity error; 

        entrada <= "10100010010011101010111001001"; -- Condição de Erro "11110" P5 downto P2
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando ocorre erro de paridade impossível para apenas 1 bit (1/2) (Dica: Se ha erro impossivel os dados de saida sao iguais aos de entrada pois nao ha o que corrigir" severity error;
        assert(erro = '1') report "ghdlfiddle:BAD Falha em 'erro' quando ocorre erro de paridade impossivel para apenas 1 bit (1/2)" severity error; 

        entrada <= "10100010010011101010111001000"; -- Condição de Erro "11111" P5 downto P1
        wait for 1 ns;
        assert(dados = "101000100100111010101110") report "ghdlfiddle:BAD Falha em 'dados' quando ocorre erro de paridade impossível (2/2) para apenas 1 bit (Dica: Se ha erro impossivel os dados de saida sao iguais aos de entrada pois nao ha o que corrigir" severity error;
        assert(erro = '1') report "ghdlfiddle:BAD Falha em 'erro' quando ocorre erro de paridade impossivel para apenas 1 bit (2/2)" severity error; 

        assert false report "ghdlfiddle:GOOD Teste finalizado." severity note;
        wait;
    end process;

end architecture;