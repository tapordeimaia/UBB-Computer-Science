import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        String line = scanner.nextLine();
        String[] tokens = line.split("\\s+");

        int sum = 0;
        int count = 0;

        for (String token : tokens) {
            int number = Integer.parseInt(token);
            sum += number;
            count++;
        }

        double average = (double) sum / count;
        System.out.println("Average = " + average);

        scanner.close();

        Book book1 = new Book("Dictionary");

        System.out.println("Book 1 = " + book1);
    }
}
