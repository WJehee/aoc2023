import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.ArrayDeque;
import java.util.HashMap;

class Pair {
    int x;
    int y;
    int d;

    public Pair(int x, int y, int d) {
        this.x = x;
        this.y = y;
        this.d = d;
    }

    public String toString() {
        return String.format("%d, %d : %d", this.x, this.y, this.d);
    }

    public boolean equals(Object o) {
        if (o instanceof Pair) {
            Pair p = (Pair)o;
            return p.x == this.x && p.x == this.x;
        }
        return false;
    }
    public int hashCode() {
        return new Integer(this.x).hashCode() * 31 + new Integer(this.y).hashCode();
    }
    
    public char symbol(ArrayList<ArrayList<Character>> map) {
        return map.get(this.x).get(this.y);
    }
}

class Main {
    static ArrayList<ArrayList<Character>> map = new ArrayList();
    static HashMap<Pair, Integer> visited = new HashMap();
    static int max_x = 0;
    static int max_y = 0;

    public static void main(String[] args) {
        try {
            BufferedReader br = new BufferedReader(new FileReader("input.txt"));

            int current_x = 0;
            int current_y = 0;
            int i = 0;
            for (String line = br.readLine(); line != null; line = br.readLine()) {
                ArrayList<Character> row = new ArrayList();
                for (int j=0; j<line.length(); j++) {
                    char c = line.charAt(j);
                    row.add(c);
                    if (c == 'S') {
                        current_y = j;
                        current_x = i;
                    }
                    max_y = j+1;
                }
                i++;
                map.add(row);
            }
            max_x = i;
            explore(current_x, current_y);
            int maxval = 0;
            for (HashMap.Entry<Pair, Integer> pair : visited.entrySet()) {
                int value = pair.getValue();
                if (value > maxval) {
                    maxval = value;
                }
            }
            maxval++;
            System.out.println("Answer: " + maxval);
        } catch (IOException e) {
            System.out.println(e);
        }
    }

    public static void explore(int x, int y) {
        ArrayDeque<Pair> toVisit = new ArrayDeque();
        // Check viable positions to go from the start
        ArrayList<Pair> starts = new ArrayList();

        starts.add(new Pair(x-1, y, 0));
        starts.add(new Pair(x+1, y, 0));
        starts.add(new Pair(x, y-1, 0));
        starts.add(new Pair(x, y+1, 0));

        for (Pair maybeStart : starts) {
            for (Pair n : get_neighbours(maybeStart.symbol(map), maybeStart.x, maybeStart.y, 0)) {
                if (n.x == x && n.y == y) {
                    toVisit.add(maybeStart);
                    break;
                }
            }
        }

        while (toVisit.size() > 0) {
            Pair p = toVisit.remove();
            if (
                    p.x >= 0 &&
                    p.y >= 0 &&
                    p.x < max_x &&
                    p.y < max_y)
            {
                if (visited.get(p) != null) continue;
                visited.put(p, p.d);
                char c = map.get(p.x).get(p.y);
                toVisit.addAll(get_neighbours(c, p.x, p.y, p.d));
            }
        }
    }

    public static ArrayList<Pair> get_neighbours(char c, int x, int y, int d) {
        ArrayList<Pair> result = new ArrayList();
        switch (c) {
            case '|':
                result.add(new Pair(x-1, y, d+1));
                result.add(new Pair(x+1, y, d+1));
                break;
            case '-':
                result.add(new Pair(x, y-1, d+1));
                result.add(new Pair(x, y+1, d+1));
                break;
            case 'L':
                result.add(new Pair(x-1, y, d+1));
                result.add(new Pair(x, y+1, d+1));
                break;
            case 'J':
                result.add(new Pair(x-1, y, d+1));
                result.add(new Pair(x, y-1, d+1));
                break;
            case '7':
                result.add(new Pair(x+1, y, d+1));
                result.add(new Pair(x, y-1, d+1));
                break;
            case 'F':
                result.add(new Pair(x+1, y, d+1));
                result.add(new Pair(x, y+1, d+1));
                break;
        }
        return result;
    }
}
