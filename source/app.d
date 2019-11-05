import std.stdio;
import std.conv;

//borrowed from the wiki
//import std.stdio;
template isin(T) {
    bool isin(T[] Array, T Element) {
        bool rtn=false;
        foreach(T ArrayElement; Array) {
            if(Element==ArrayElement) { rtn=true; break; }
        }
        return rtn;
    }
}

// Attempt at a layered tree, linkages maintained externally to the tree nodes
class multitree {
    Node[][] siblings;

    this(int start, int end) {
        auto root = new Node(start, end, "root");
        this.siblings.length = 8;
        this.siblings[0] ~= root;
    }

    void addNode(int start, int end, string label) {
        auto newNode = new Node(start, end, label);
        int ix = 0;
        while(ix < siblings.length) {
            bool collision = false;
            foreach(node; this.siblings[ix]) {
                collision |= node.checkCollision(newNode);
            }
            if (!collision) {
                this.siblings[ix] ~= newNode;
                foreach(node; this.siblings[ix-1]) {
                    if (node.checkCollision(newNode)) {
                        newNode.addParent(node);
                        node.addChild(newNode);
                    }
                }
                foreach(node; this.siblings[ix+1]) {
                    if (node.checkCollision(newNode)) {
                        node.addParent(newNode);
                        newNode.addChild(node);
                    }
                }
            }
            if (!collision) { break; }
            ix++;
        }
    }

    void testPrint() {
        foreach(lvl; this.siblings) {
            foreach(node; lvl) {
                writeln("node\t" ~ node.label ~ "\t" ~ to!string(node.st) ~ "\t" ~ to!string(node.en));
            }
        }
        writeln(this.siblings);
    }

    class Node {
        int st;
        int en;
        string label;
        Node[] parents;
        Node[] children;

        this(int start, int end, string label) {
            this.st = start;
            this.en = end;
            this.label = label;
        }

        bool checkCollision(Node check) {
            if ((this.en > check.st) && (check.en > this.st)) return true;
            else return false;
        }

        void addParent(Node n) {
            this.parents ~= n;
        }

        void addChild(Node n) {
            this.children ~= n;
        }
    }
}

class primitiveTree {
    Node root;

    this(int start, int end) {
        this.root = new Node(start, end, "root");
    }

    void addNode(int start, int end, string label) {
        auto newNode = Node(start, end, label);
        this.root.addNode(newNode);
    }

    class Node {
        int st;
        int en;
        string label;
        Node[] parents;
        Node[] siblings;
        Node[] children;

        this(int start, int end, string label) {
            this.st = start;
            this.en = end;
            this.label = label;
        }

        void addNode(Node n) {
            if (!this.checkLevel(n)) {
                this.synchronize(n);
                foreach(parent; this.parents) { parent.setChildren(n); break; }
                foreach(child; this.children) { child.setParents(n); break; }
            }
            else {
                foreach(child; this.children) { child.addNode(n); break; }
            }
        }

        bool checkLevel(Node check) {
            bool collision = this.checkCollision(check);
            if(!collision) {
                foreach(sibling; this.siblings) {
                    collision |= sibling.checkCollision(check);
                }
            }
            return collsion;
        }

        bool checkCollision(Node check) {
            if ((this.en > check.st) && (check.en > this.st)) return true;
            else return false;
        }

        void synchronize(Node n) {
            foreach(sibling; this.siblings) {
                sibling.siblings ~= n;
            }
            this.siblings ~= n;
            n.siblings = this.siblings;
        }

        void setParents(Node n) {
            if (this.checkCollision(n)) { this.addParent(n); }
            foreach(sibling; this.siblings) {
                if (sibling.checkCollision(n)) { sibling.addParent(n); }
            }
        }

        void addParent(Node n) {
            this.parents ~= n;
            n.children ~= this;
        }

        void setChildren(Node n) {
            if (this.checkCollision(n)) { this.addChild(n); }
            foreach(sibling; this.siblings) {
                if (sibling.checkCollision(n)) { sibling.addChild(n); }
            }
        }

        void addChild(Node n) {
            this.children ~= n;
            n.parents ~= this;
        }
    }
}

class naiveMultiTree {
    naiveNode root;

    this() {
        this.root = new naiveNode(0, true);
    }

    void addNode(int id, int[] parentIds) {
        auto newNode = new naiveNode(id);
        this.root.checkParent(newNode, parentIds);
    }

    void testPrint2() {
        this.root.testPrint("");
    }


    class naiveNode {
        int id;
        bool superNode = false;
        naiveNode[] parents;
        naiveNode[] children;

        this(int id, bool isSuper = false) {
            this.id = id;
            this.superNode = isSuper;
        }

        void checkParent(naiveNode check, int[] parentIds) {
            if (parentIds.isin(this.id)) {
                this.children ~= check;
                check.parents ~= this;
            }
            foreach(child; this.children) {
                child.checkParent(check, parentIds);
            }
        }

        void testPrint(string prefix = "") {
            writeln(prefix ~ "id <" ~ to!string(this.id) ~ "> with children:");
            foreach(child; this.children) { child.testPrint(prefix~"\t"); }
        }
    }
}

void main()
{
    //testTuple1 = tuple(0,10);
    //testTuple2 = tuple(1,3);
    //writeln(testTuple1);
    //writeln(testTuple2);
    writeln("---");
    auto tree = new multitree(0, 10);
    tree.testPrint;
    tree.addNode(1, 3, "first");
    tree.addNode(5, 8, "second");
    tree.addNode(2, 6, "third");
    tree.testPrint;
    writeln("---");
    auto tree2 = new multitree(0, 10);
    tree2.addNode(1, 3, "first");
    tree2.addNode(2, 6, "second");
    tree2.addNode(5, 8, "third");
    tree2.testPrint;
    writeln("---");
    auto tree3 = new naiveMultiTree();
    tree3.testPrint2();
    tree3.addNode(1, [0]);
    tree3.addNode(2, [0]);
    tree3.addNode(3, [1]);
    tree3.addNode(4, [1,2]);
    tree3.addNode(5, [2]);
    tree3.testPrint2();
    writeln("---");
    int[string][] testList;
    testList.length = 20;
    //testList["root"][0] ~= 0;
    writeln(testList);
    writeln(testList.length);
    writeln(typeof(testList[0]).stringof);
    testList[0]["root"] = 0;
    testList[1]["one"] = 1;
    testList[1]["two"] = 1;
    testList[2]["three"] = 2;
    testList[2]["four"] = 1;
    writeln(testList);
    writeln(testList.length);
    writeln("---");
    string[][] testList2;
    testList2.length = 8;
    writeln(testList2);
    testList2[0] ~= "root";
    testList2[1] ~= "one";
    testList2[2] ~= "two";
    testList2[1] ~= "three";
    testList2[2] ~= "four";
    testList2[2] ~= "two";
    testList2[2] ~= "four";
    writeln(testList2);
}
