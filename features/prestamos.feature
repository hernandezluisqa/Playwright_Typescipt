# language: es
@prestamos
Feature: Préstamos personales
  Como usuario autenticado
  Quiero solicitar y consultar préstamos
  Para financiar mis necesidades con cuotas fijas

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @alto @smoke @TC-LOAN-001
  Scenario: Solicitud exitosa de préstamo a 12 cuotas
    When solicito un préstamo con los siguientes datos:
      | monto           | 200000.00 |
      | cuotas          | 12        |
      | cuenta_destino  | ACC001    |
    Then la respuesta debe tener status code 200
    And el campo "exito" debe ser true
    And el préstamo debe estar aprobado
    And la cuota mensual debe ser aproximadamente 27500.00
    And el monto debe haber sido acreditado en "ACC001"

  @medio @TC-LOAN-002
  Scenario: Rechazo por monto menor al mínimo permitido
    When solicito un préstamo con los siguientes datos:
      | monto          | 5000.00 |
      | cuotas         | 6       |
      | cuenta_destino | ACC001  |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "MONTO_MINIMO"

  @medio @TC-LOAN-003
  Scenario: Rechazo por cantidad de cuotas no permitida
    When solicito un préstamo con los siguientes datos:
      | monto          | 100000.00 |
      | cuotas         | 10        |
      | cuenta_destino | ACC001    |
    Then el campo "exito" debe ser false
    And el mensaje debe indicar un error de validación en el campo cuotas

  @medio
  Scenario: Rechazo por monto mayor al máximo permitido
    When solicito un préstamo con los siguientes datos:
      | monto          | 600000.00 |
      | cuotas         | 48        |
      | cuenta_destino | ACC001    |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "MONTO_INVALIDO"

  @medio
  Scenario: Rechazo por superar el máximo de préstamos activos
    Given el usuario ya tiene 3 préstamos activos
    When solicito un préstamo con los siguientes datos:
      | monto          | 50000.00 |
      | cuotas         | 12       |
      | cuenta_destino | ACC001   |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "MAXIMO_ALCANZADO"

  @alto @smoke
  Scenario: Consultar lista de préstamos activos
    When consulto los préstamos en "GET /prestamos/"
    Then la respuesta debe tener status code 200
    And la respuesta debe ser una lista

  @medio
  Scenario Outline: Validar cuotas permitidas para solicitud de préstamo
    When solicito un préstamo con los siguientes datos:
      | monto          | 100000.00 |
      | cuotas         | <cuotas>  |
      | cuenta_destino | ACC001    |
    Then el campo "exito" debe ser true

    Examples:
      | cuotas |
      | 6      |
      | 12     |
      | 18     |
      | 24     |
      | 36     |
      | 48     |
