# language: es
@plazos-fijos
Feature: Plazos fijos
  Como usuario autenticado
  Quiero gestionar mis plazos fijos
  Para invertir mi dinero y obtener rendimientos

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @alto @smoke @TC-PF-001
  Scenario: Creación exitosa de plazo fijo a 90 días
    Given la cuenta "ACC001" tiene saldo suficiente
    When creo un plazo fijo con los siguientes datos:
      | cuenta_origen | ACC001   |
      | monto         | 50000.00 |
      | plazo_dias    | 90       |
    Then la respuesta debe tener status code 200
    And el campo "exito" debe ser true
    And el plazo fijo debe tener TNA del 42%
    And el interés estimado debe ser aproximadamente 5178.08
    And el saldo de "ACC001" debe haber disminuido en 50000.00
    And se debe haber generado una transacción de tipo "debit"

  @medio @TC-PF-002
  Scenario: Rechazo por monto menor al mínimo permitido
    When creo un plazo fijo con los siguientes datos:
      | cuenta_origen | ACC001 |
      | monto         | 500.00 |
      | plazo_dias    | 30     |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "MONTO_MINIMO"

  @medio @TC-PF-003
  Scenario: Rechazo por superar el máximo de plazos fijos activos
    Given el usuario ya tiene 5 plazos fijos activos
    When creo un plazo fijo con los siguientes datos:
      | cuenta_origen | ACC001    |
      | monto         | 10000.00  |
      | plazo_dias    | 30        |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "MAXIMO_ALCANZADO"

  @alto @TC-PF-004
  Scenario: Cancelación de plazo fijo antes del vencimiento
    Given existe un plazo fijo activo con ID conocido
    When cancelo el plazo fijo con ese ID
    Then la respuesta debe tener status code 200
    And el plazo fijo debe estar en estado "cancelled"
    And el monto debe haber sido devuelto a la cuenta origen sin intereses
    And se debe haber generado una transacción de tipo "credit"

  @alto @smoke
  Scenario: Consultar lista de plazos fijos activos
    When consulto los plazos fijos en "GET /plazos-fijos/"
    Then la respuesta debe tener status code 200
    And la respuesta debe ser una lista

  @medio
  Scenario Outline: Validar TNA según plazo contratado
    When creo un plazo fijo con los siguientes datos:
      | cuenta_origen | ACC001  |
      | monto         | 5000.00 |
      | plazo_dias    | <plazo> |
    Then el campo "exito" debe ser true
    And el plazo fijo debe tener TNA del <tna>%

    Examples:
      | plazo | tna |
      | 30    | 35  |
      | 60    | 38  |
      | 90    | 42  |
      | 180   | 45  |
      | 360   | 50  |

  @medio
  Scenario: Rechazo por saldo insuficiente en cuenta origen
    When creo un plazo fijo con los siguientes datos:
      | cuenta_origen | ACC001      |
      | monto         | 999999.00   |
      | plazo_dias    | 30          |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "FONDOS_INSUFICIENTES"
