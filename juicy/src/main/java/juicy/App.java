package juicy;

public class App {
    public String getGreeting() {
        return "Hello world.";
    }

    public static void main(String[] args) {
        System.out.println(new App().getGreeting());

        SwingExample ui = new SwingExample();
        ui.Run();

        // LookAndFeelDemo demo = new LookAndFeelDemo();
        // demo.Run();
    }
}
