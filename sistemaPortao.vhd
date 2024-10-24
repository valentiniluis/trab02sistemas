library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sistemaPortao is
    port(
        clk: in std_logic;
        B, S: in std_logic;
        SA, SF: out std_logic
    );
end sistemaPortao;

architecture Behaviour of sistemaPortao is

    TYPE estado is (E0, E1, E2, E3);
    signal estado_atual: estado := E0;
    signal A : std_logic := '0';
    signal F : std_logic := '0';

begin

    updateProcess : process(B, S)
    begin

        IF (B='1') THEN SA <= '1'; ELSE SA <= '0'; END if;

        IF (S='1') THEN
            IF (A='1' and F='0') THEN
                A <= '0';
                F <= '1';
            ELSIF (A='0' and F='1') THEN
                A <= '1';
                F <= '0';
            END IF;
        ELSIF (B='1') THEN
            IF (estado_atual=E0) THEN
                F <= '0';
                A <= '1';
            ELSIF (estado_atual=E3) THEN
                F <= '1';
                A <= '0';
            END IF;
        END IF;
    end process;

    clockProcess: process(clk)
    begin

        IF (clk'event and clk='1') THEN
            IF (estado_atual=E0) THEN
                IF (A='1' and F='0') THEN
                    estado_atual <= E1;
                    SF <= '0';
                ELSE SF <= '1';
                END IF;
            
            ELSIF (estado_atual=E3) THEN
                IF (A='0' and F='1') THEN
                    estado_atual <= E2;
                    SA <= '0';
                END IF;
            
            ELSIF (estado_atual=E1) THEN
                IF (A='1' and F='0') THEN estado_atual <= E2;
                ELSIF (A='0' and F='1') THEN
                    estado_atual <= E0;
                    F <= '0';
                    SF <= '1';
                END IF;
            
            ELSE
                IF (A='1' and F='0') THEN
                    estado_atual <= E3;
                    A <= '0';
                    SA <= '1';
                ELSIF (A='0' and F='1') THEN estado_atual <= E1;
                END IF;
            END IF;
        END IF;
    end process;

end Behaviour;
