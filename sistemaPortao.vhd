library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sistemaPortao is
    port(
        
        clk, reset: in std_logic;
        B, S: in std_logic;
        
        SA, SF, A, F: out std_logic
    );
end sistemaPortao;

architecture Behaviour of sistemaPortao is

    TYPE estado is (E0, E1, E2, E3);
    signal estado_atual: estado := E0;
    signal Abrindo_signal : std_logic := '0';
    signal Fechando_signal : std_logic := '0';

begin

    process(clk, reset)

    variable Abrindo_variable : std_logic := Abrindo_signal;
    variable Fechando_variable : std_logic := Fechando_signal;

    begin

        IF (reset='1') THEN
            estado_atual <= E0;
            SA <= '0';
            SF <= '1';
            A <= '0';
            F <= '0';

        ELSIF (clk'event and clk='1') THEN

            ------------------------------------------
            -- LÓGICA DE MOVIMENTAÇÃO DA PORTA (A & F)
            IF (S='1') THEN
                IF (Abrindo_variable='1' and Fechando_variable='0') THEN
                    Abrindo_variable := '0';
                    Fechando_variable := '1';
                ELSIF (Abrindo_variable='0' and Fechando_variable='1') THEN
                    Abrindo_variable := '1';
                    Fechando_variable := '0';
                END IF;

            ELSIF (B='1') THEN
                IF (estado_atual=E0) THEN
                    Fechando_variable := '0';
                    Abrindo_variable := '1';
                ELSIF (estado_atual=E3) THEN
                    Fechando_variable := '1';
                    Abrindo_variable := '0';
                END IF;
            END IF;
            ------------------------------------------


            ------------------------------------------
            -- LÓGICA DE TROCA DE ESTADOS
            IF (estado_atual=E0) THEN
                IF (Abrindo_variable='1' and Fechando_variable='0') THEN
                    estado_atual <= E1;
                    SF <= '0';
                ELSE SF <= '1';
                END IF;
            
            ELSIF (estado_atual=E3) THEN
                IF (Abrindo_variable='0' and Fechando_variable='1') THEN
                    estado_atual <= E2;
                    SA <= '0';
                END IF;
            
            ELSIF (estado_atual=E1) THEN
                IF (Abrindo_variable='1' and Fechando_variable='0') THEN estado_atual <= E2;
                ELSIF (A='0' and F='1') THEN
                    estado_atual <= E0;
                    Fechando_variable := '0';
                    SF <= '1';
                END IF;
            
            ELSE
                IF (Abrindo_variable='1' and Fechando_variable='0') THEN
                    estado_atual <= E3;
                    Abrindo_variable := '0';
                    SA <= '1';
                ELSIF (Abrindo_variable='0' and Fechando_variable='1') THEN estado_atual <= E1;
                END IF;
            END IF;

            Abrindo_signal <= Abrindo_variable;
            Fechando_signal <= Fechando_variable;

            A <= Abrindo_variable;
            F <= Fechando_variable;

        END IF;
        ------------------------------------------

        
    end process;

end Behaviour;
