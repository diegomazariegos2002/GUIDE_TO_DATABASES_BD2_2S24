# Principios SOLID en Programación Orientada a Objetos

Los principios **SOLID** son cinco reglas fundamentales que ayudan a escribir código más limpio, mantenible y escalable en la Programación Orientada a Objetos (POO). Considero que si son bien importantes y más cuando se trabajan en proyectos muy grandes donde si es vital mantener un orden como tal.

---

## 🟢 1. **Principio de Responsabilidad Única (SRP)**
👉 *"Una clase debe tener una única razón para cambiar."*

### ❌ Código incorrecto:
```java
class Reporte {
    public void generarReporte() {
        // Generar el reporte
    }

    public void imprimirReporte() {
        // Imprimir el reporte
    }
}
```

❌ Aquí la clase Reporte tiene dos responsabilidades: generar e imprimir el reporte.

### ✅ Código correcto:
```java
class Reporte {
    public void generarReporte() {
        // Generar el reporte
    }
}

class Impresora {
    public void imprimirReporte(Reporte reporte) {
        // Imprimir el reporte
    }
}
```
✅ Ahora cada clase tiene una sola responsabilidad.

## 🟢 2. Principio de Abierto/Cerrado (OCP)
👉 "Las clases deben estar abiertas para la extensión, pero cerradas para la modificación."

### ❌ Código incorrecto:
```java
class Calculadora {
    public double calcularArea(String tipo, double valor) {
        if (tipo.equals("circulo")) {
            return Math.PI * valor * valor;
        } else if (tipo.equals("cuadrado")) {
            return valor * valor;
        }
        return 0;
    }
}
```

❌ Aquí la clase Calculadora debe ser modificada cada vez que se quiera agregar una nueva figura geométrica.

### ✅ Código correcto:
```java
abstract class Figura {
    abstract double calcularArea();
}

class Circulo extends Figura {
    private double radio;
    
    public Circulo(double radio) { this.radio = radio; }
    
    @Override
    double calcularArea() { return Math.PI * radio * radio; }
}

class Cuadrado extends Figura {
    private double lado;
    
    public Cuadrado(double lado) { this.lado = lado; }
    
    @Override
    double calcularArea() { return lado * lado; }
}
```

✅ Ahora se pueden agregar nuevas figuras geométricas sin modificar la clase Calculadora.

## 🟢 3. Principio de Sustitución de Liskov (LSP)

👉 "Las subclases deben poder sustituir a sus superclases sin alterar el comportamiento esperado."

### ❌ Código incorrecto:

```java
class Ave {
    public void volar() { System.out.println("Volando"); }
}

class Pinguino extends Ave {
    @Override
    public void volar() {
        throw new UnsupportedOperationException("Los pingüinos no vuelan");
    }
}
```

❌ Aquí la subclase Pinguino no debería heredar de la superclase Ave.

### ✅ Código correcto:

```java
interface Ave {
    void volar();
}

class Loro implements Ave {
    @Override
    public void volar() { System.out.println("Volando"); }
}

class Pinguino implements Ave {
    @Override
    public void volar() { System.out.println("Nadando"); }
}
```

✅ Ahora las clases Loro y Pinguino implementan la interfaz Ave.

## 🟢 4. Principio de Segregación de Interfaces (ISP)

👉 "Una interfaz no debe obligar a implementar métodos que no se necesitan."

### ❌ Código incorrecto:

```java
interface Trabajador {
    void programar();
    void diseñar();
}

class Programador implements Trabajador {
    public void programar() { System.out.println("Programando"); }
    public void diseñar() { throw new UnsupportedOperationException(); }
}
```

❌ Un programador no debería verse obligado a implementar diseñar.

### ✅ Código correcto:

```java
interface Programador {
    void programar();
}

interface Diseñador {
    void diseñar();
}

class IngenieroSoftware implements Programador {
    public void programar() { System.out.println("Programando"); }
}

class DiseñadorGrafico implements Diseñador {
    public void diseñar() { System.out.println("Diseñando"); }
}

```

✅ Ahora cada clase implementa solo lo que necesita.

## 🟢 5. Principio de Inversión de Dependencias (DIP)

👉 "Dependa de abstracciones, no de implementaciones. Los módulos de alto nivel no deben depender de módulos de bajo nivel, sino de abstracciones"

### ❌ Código incorrecto:

```java
class Lampara {
    public void encender() { System.out.println("Lámpara encendida"); }
}

class Interruptor {
    private Lampara lampara;
    
    public Interruptor() { this.lampara = new Lampara(); }
    
    public void encenderLampara() { lampara.encender(); }
}
```

❌ Aquí la clase Interruptor depende directamente de la clase Lampara.

### ✅ Código correcto:

```java
interface Dispositivo {
    void encender();
}

class Lampara implements Dispositivo {
    public void encender() { System.out.println("Lámpara encendida"); }
}

class Interruptor {
    private Dispositivo dispositivo;
    
    public Interruptor(Dispositivo dispositivo) {
        this.dispositivo = dispositivo;
    }
    
    public void encenderDispositivo() {
        dispositivo.encender();
    }
}
```

✅ Ahora la clase Interruptor depende de la interfaz Dispositivo.


# Conclusión
Los principios SOLID ayudan a escribir código más modular, flexible y fácil de mantener. Implementarlos correctamente evita el código espagueti y facilita la escalabilidad de nuestros sistemas. Por eso, considero que es importante también saber sobre herramientas como sonarqube, que nos ayudan a identificar problemas en nuestro código y nos dan sugerencias para mejorar. Además, se pueden ir complementando con otros principios como el DRY (Don't Repeat Yourself) y el KISS (Keep It Simple, Stupid).