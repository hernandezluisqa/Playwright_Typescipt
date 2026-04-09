# language: es
@tarjetas
Feature: Tarjetas virtuales
  Como usuario autenticado
  Quiero gestionar mis tarjetas virtuales
  Para realizar pagos digitales de forma segura

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @alto @smoke @TC-CARD-001
  Scenario: Generación exitosa de tarjeta virtual
    When genero una tarjeta virtual con los siguientes datos:
      | id_cuenta_asociada | ACC001 |
    Then la respuesta debe tener status code 200
    And el campo "exito" debe ser true
    And el número de tarjeta debe tener 16 dígitos
    And el número de tarjeta debe comenzar con "4"
    And el CVV debe tener 3 dígitos
    And la fecha de vencimiento debe ser aproximadamente 3 años desde hoy
    And el estado de la tarjeta debe ser "active"

  @medio @TC-CARD-002
  Scenario: Rechazo al generar tarjeta cuando la cuenta ya tiene una activa
    Given la cuenta "ACC001" ya tiene una tarjeta virtual activa
    When genero una tarjeta virtual con los siguientes datos:
      | id_cuenta_asociada | ACC001 |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "YA_TIENE_TARJETA"

  @alto @TC-CARD-003
  Scenario: Eliminación exitosa de tarjeta virtual
    Given existe una tarjeta virtual activa con ID conocido
    When elimino la tarjeta virtual con ese ID
    Then la respuesta debe tener status code 200
    And la tarjeta no debe aparecer en el listado de tarjetas activas

  @alto @smoke
  Scenario: Consultar listado de tarjetas virtuales activas
    When consulto las tarjetas en "GET /tarjetas/virtuales"
    Then la respuesta debe tener status code 200
    And la respuesta debe ser una lista

  @medio
  Scenario: Rechazo por cuenta inexistente al generar tarjeta
    When genero una tarjeta virtual con los siguientes datos:
      | id_cuenta_asociada | ACC999 |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "CUENTA_INVALIDA"

  @medio
  Scenario: Rechazo al eliminar una tarjeta con ID inexistente
    When elimino la tarjeta virtual con ID "CARD_INEXISTENTE"
    Then la respuesta debe tener status code 404
