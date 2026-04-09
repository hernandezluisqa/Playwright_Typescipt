# language: es
@transferencias
Feature: Transferencias bancarias
  Como usuario autenticado
  Quiero realizar transferencias entre cuentas
  Para mover dinero de forma segura y controlada

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @critico @smoke @TC-TRF-001
  Scenario: Transferencia exitosa entre cuentas propias
    Given la cuenta "ACC001" tiene saldo suficiente
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001                  |
      | cuenta_destino | ACC002                  |
      | monto          | 5000.00                 |
      | motivo         | Transferencia de prueba |
      | tipo           | propia                  |
    Then la respuesta debe tener status code 200
    And el campo "exito" debe ser true
    And el saldo de "ACC001" debe haber disminuido en 5000.00
    And se debe haber generado una transacción de tipo "debit"

  @critico @TC-TRF-002
  Scenario: Rechazo por monto menor al mínimo permitido
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001 |
      | cuenta_destino | ACC002 |
      | monto          | 0.50   |
      | tipo           | propia |
    Then la respuesta debe tener status code 200
    And el campo "exito" debe ser false
    And el campo "error" debe ser "MONTO_INVALIDO"
    And el mensaje debe indicar "El monto mínimo es $1"

  @critico @TC-TRF-003
  Scenario: Rechazo por exceder el límite máximo por transferencia
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001  |
      | cuenta_destino | ACC002  |
      | monto          | 55000   |
      | tipo           | propia  |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "LIMITE_EXCEDIDO"
    And el mensaje debe indicar "Monto máximo por transferencia superado"

  @alto @TC-TRF-004
  Scenario: Rechazo por límite diario excedido
    Given ya se han realizado transferencias por un total de 60000.00 en el día
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001 |
      | cuenta_destino | ACC002 |
      | monto          | 45000  |
      | tipo           | propia |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "LIMITE_DIARIO_EXCEDIDO"
    And el mensaje debe indicar "Límite diario excedido"

  @critico @TC-TRF-005
  Scenario: Rechazo por saldo insuficiente
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001   |
      | cuenta_destino | ACC002   |
      | monto          | 200000   |
      | tipo           | propia   |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "FONDOS_INSUFICIENTES"
    And el mensaje debe indicar "Saldo insuficiente"

  @alto @TC-TRF-006
  Scenario: Transferencia exitosa a terceros con CBU válido
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001                 |
      | cuenta_destino | 0170009876543210987654 |
      | monto          | 3000.00                |
      | tipo           | terceros               |
    Then el campo "exito" debe ser true
    And el saldo de "ACC001" debe haber disminuido en 3000.00

  @alto @TC-TRF-007
  Scenario: Rechazo por CBU inválido con menos de 10 caracteres
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001   |
      | cuenta_destino | 123456   |
      | monto          | 3000.00  |
      | tipo           | terceros |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "DESTINO_INVALIDO"

  @alto @smoke
  Scenario: Consultar límites de transferencia
    When consulto los límites de transferencia en "GET /transferencias/limites"
    Then la respuesta debe tener status code 200
    And la respuesta debe incluir el límite por transferencia de 50000.00
    And la respuesta debe incluir el límite diario de 100000.00

  @alto @smoke
  Scenario: Consultar lista de beneficiarios guardados
    When consulto los beneficiarios en "GET /transferencias/beneficiarios"
    Then la respuesta debe tener status code 200
    And la respuesta debe ser una lista
