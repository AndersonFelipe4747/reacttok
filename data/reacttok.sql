CREATE DATABASE IF NOT EXISTS `reacttok` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `reacttok`;

CREATE TABLE IF NOT EXISTS `categorias_conceito` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nome_categoria` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Ex: Hooks Essenciais, Fundamentos',
  `descricao_categoria` VARCHAR(255) NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE = InnoDB 
COMMENT = 'Tabela de agrupamento para organização didática dos conceitos.';


CREATE TABLE IF NOT EXISTS `conceitos_rn` (
  `id_conceito` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Chave primária textual (e.g., jsx, state)',
  `titulo` VARCHAR(100) NOT NULL COMMENT 'Título principal do conceito (e.g., useState)',
  `resumo` VARCHAR(255) NOT NULL COMMENT 'Descrição breve para cards',
  `explicacao_completa` TEXT NOT NULL COMMENT 'Explanação detalhada do conceito',
  `id_categoria_fk` INT NULL,
  PRIMARY KEY (`id_conceito`),
  FOREIGN KEY (`id_categoria_fk`) REFERENCES `categorias_conceito`(`id_categoria`)
    ON DELETE SET NULL -- Mantém o conceito mesmo se a categoria for removida
    ON UPDATE CASCADE -- Atualiza o FK se o PK na Categoria mudar
) ENGINE = InnoDB 
COMMENT = 'Informações principais sobre os conceitos de React Native.';


CREATE TABLE IF NOT EXISTS `exemplos_codigo` (
  `id_exemplo` INT NOT NULL AUTO_INCREMENT,
  `id_conceito_fk` VARCHAR(50) NOT NULL,
  `tipo_codigo` ENUM('SHORT', 'FULL') NOT NULL COMMENT 'SHORT (Resumido) ou FULL (Completo)',
  `codigo_fonte` TEXT NOT NULL,
  PRIMARY KEY (`id_exemplo`),
  UNIQUE KEY `uk_conceito_tipo` (`id_conceito_fk`, `tipo_codigo`), -- Restrição para garantir unicidade
  FOREIGN KEY (`id_conceito_fk`) REFERENCES `conceitos_rn`(`id_conceito`)
    ON DELETE CASCADE -- Remove os códigos se o conceito for removido
    ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Armazena os trechos de código curtos e completos.';


INSERT INTO `categorias_conceito` (`nome_categoria`, `descricao_categoria`) VALUES
('Fundamentos', 'Base de componentes e JSX'),
('Hooks Essenciais', 'Hooks de estado e ciclo de vida'),
('Estilização', 'Métodos para design da interface'),
('APIs Nativas', 'Acesso a funcionalidades do dispositivo');


INSERT INTO `conceitos_rn` (`id_conceito`, `titulo`, `resumo`, `explicacao_completa`, `id_categoria_fk`) VALUES
('jsx', 'Componentes + JSX', 'A base de tudo: Funções que retornam UI.', 'Em React Native, componentes são funções JavaScript que retornam JSX (uma sintaxe parecida com HTML). Eles são os blocos de construção da sua interface.', (SELECT id_categoria FROM categorias_conceito WHERE nome_categoria = 'Fundamentos')),
('state', 'useState', 'Memória do componente. Quando muda, a tela atualiza.', 'O Hook useState permite adicionar estado ao componente. Quando você chama a função "set", o React re-renderiza o componente com o novo valor.', (SELECT id_categoria FROM categorias_conceito WHERE nome_categoria = 'Hooks Essenciais')),
('effect', 'useEffect', 'Efeitos colaterais: timers, APIs, mudanças.', 'O Hook useEffect executa código em momentos específicos: quando o componente nasce (mount), quando algo muda (update) ou quando morre (unmount).', (SELECT id_categoria FROM categorias_conceito WHERE nome_categoria = 'Hooks Essenciais')),
('style', 'StyleSheet', 'Estilização otimizada parecida com CSS.', 'A API StyleSheet cria objetos de estilo. É mais performática que objetos literais e valida as propriedades. Usa Flexbox para layout por padrão.', (SELECT id_categoria FROM categorias_conceito WHERE nome_categoria = 'Estilização')),
('vibration', 'APIs Nativas', 'Acesse hardware como Vibração facilmente.', 'React Native e Expo fornecem acesso direto a funcionalidades do dispositivo. Vibration, Camera, Location e Sensors são exemplos comuns.', (SELECT id_categoria FROM categorias_conceito WHERE nome_categoria = 'APIs Nativas'));



INSERT INTO `exemplos_codigo` (`id_conceito_fk`, `tipo_codigo`, `codigo_fonte`) VALUES

('jsx', 'SHORT', 'function Hello() {
  return <Text>Olá!</Text>
}'),
('jsx', 'FULL', 'import React from \'react\';
import { Text, View } from \'react-native\';

export default function Welcome() {
  return (
    <View style={{ padding: 20 }}>
      <Text style={{ color: \'white\' }}>
        Bem-vindo ao React Native!
      </Text>
    </View>
  );
}'),

-- Conceito: state (useState)
('state', 'SHORT', 'const [count, setCount] = useState(0);'),
('state', 'FULL', 'import React, { useState } from \'react\';
import { Button, Text, View } from \'react-native\';

export default function Counter() {
  const [count, setCount] = useState(0);

  return (
    <View>
      <Text>Contagem: {count}</Text>
      <Button 
        title="Aumentar" 
        onPress={() => setCount(count + 1)} 
      />
    </View>
  );
}'),

-- Conceito: effect (useEffect)
('effect', 'SHORT', 'useEffect(() => {
  console.log(\'Montou!\');
}, []);'),
('effect', 'FULL', 'import React, { useState, useEffect } from \'react\';
import { Text, View } from \'react-native\';

export default function Timer() {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setSeconds(s => s + 1);
    }, 1000);
    
    -- Limpeza ao desmontar
    return () => clearInterval(interval);
  }, []);

  return <Text>Segundos: {seconds}</Text>;
}'),

-- Conceito: style (StyleSheet)
('style', 'SHORT', 'const styles = StyleSheet.create({
  box: { color: \'red\' }
});'),
('style', 'FULL', 'import React from \'react\';
import { View, Text, StyleSheet } from \'react-native\';

export default function Box() {
  return (
    <View style={styles.container}>
      <View style={styles.box} />
      <Text style={styles.text}>Estilo Legal</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: \'center\',
    alignItems: \'center\',
  },
  box: {
    width: 100,
    height: 100,
    backgroundColor: \'#ff2d55\',
    borderRadius: 10,
    marginBottom: 20,
  },
  text: {
    color: \'white\',
    fontSize: 20,
    fontWeight: \'bold\',
  }
});'),

-- Conceito: vibration (APIs Nativas)
('vibration', 'SHORT', 'import { Vibration } from \'react-native\';
Vibration.vibrate();'),
('vibration', 'FULL', 'import React from \'react\';
import { Button, Vibration, View } from \'react-native\';

export default function Buzz() {
  return (
    <View>
      <Button
        title="Vibrar Celular"
        onPress={() => Vibration.vibrate(500)}
      />
    </View>
  );
}');