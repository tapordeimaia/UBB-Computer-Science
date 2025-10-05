public class Item {
    public String title;

    public Item(String title) {
        this.title = title;
    }

    @Override
    public String toString() {
        return "Item{" + "title=" + title + '}';
    }
}
