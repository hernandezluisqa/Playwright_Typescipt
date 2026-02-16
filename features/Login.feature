Feature: Inicio de sesion
  @LoginSuccess
  Scenario: Usuario inicia sesion exitosamente
    Given el usuario se encuenta en la pagina de Login de Home Banking
    When ingresa el usuario "demo" y la contraseña "demo123"
    And hace clic en el botón Ingresar
    Then debería ser redirigido al panel principal del usuario "Juan Pérez"

  Scenario Outline: Login con Credenciales Inválidas
    Given el usuario se encuenta en la pagina de Login de Home Banking
    When ingresa el usuario "<username>" y la contraseña "<password>"
    And hace clic en el botón Ingresar
    Then se muestra mensaje de error 
    And permanece en Login

    Examples:
      | username | password     |
      | demo     | demo123fail  |
      | demofail | demo123      |
      | demofail | demo123fail  |
