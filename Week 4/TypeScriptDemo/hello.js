var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
function hello(someone) {
    return "Hello, " + someone;
}
var person = "Mehrab Rahman";
document.body.innerHTML = hello(person);
//3 basic types
var isDone = false;
var num = 42;
var myName = "Mehrab";
var isNotDone = true;
//When type is unknown
var notSure = 4;
notSure = "maybe a string now";
notSure = false;
//collections
var list = [1, 2, 3];
var genlist = [1, 2, 3];
var Color;
(function (Color) {
    Color[Color["Black"] = 0] = "Black";
    Color[Color["White"] = 1] = "White";
    Color[Color["Red"] = 2] = "Red";
})(Color || (Color = {}));
;
var c = Color.White;
//if function returns nothing, it's void
function bigAlert() {
    alert("Big Alert!");
}
//lambdas
var f1 = function (i) {
    return i + i;
};
var f2 = function (i) { return i + i; };
var a = { name: "Jonathan", move: function () { } };
var Point = /** @class */ (function () {
    function Point(x, y) {
        this.x = x;
        this.y = y;
    }
    Point.prototype.dist = function () {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    };
    return Point;
}());
//Inheritance
var Point3D = /** @class */ (function (_super) {
    __extends(Point3D, _super);
    function Point3D(x, y, z) {
        var _this = _super.call(this, x, y) || this;
        _this.z = z;
        return _this;
    }
    //Overwriting
    Point3D.prototype.dist = function () {
        var d = _super.prototype.dist.call(this);
        return Math.sqrt(d * d + this.z * this.z);
    };
    return Point3D;
}(Point));
//Modules "." operator can separate submodules
var Geometry;
(function (Geometry) {
    var Square = /** @class */ (function () {
        function Square(sideLength) {
            if (sideLength === void 0) { sideLength = 0; }
            this.sideLength = sideLength;
        }
        Square.prototype.area = function () {
            return Math.pow(this.sideLength, 2);
        };
        return Square;
    }());
    Geometry.Square = Square;
})(Geometry || (Geometry = {}));
var s1 = new Geometry.Square(5);
//Generics
var Tuple = /** @class */ (function () {
    function Tuple(item1, item2) {
        this.item1 = item1;
        this.item2 = item2;
    }
    return Tuple;
}());
//Template strings
var newName = "Mehrab";
var greeting = "Hi " + newName + ", how are you?";
