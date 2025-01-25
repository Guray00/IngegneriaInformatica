class Snowflake {
    constructor(x, y, ctx) {
        this.x_pos = x;
        this.y_pos = y;
        this.ctx = ctx;
        this.size = Math.max(0.3, Math.random());
        this.rotation = Math.PI*Math.random();
    }

    drawLines() {
        this.ctx.beginPath();
        this.ctx.lineWidth = 2;
        this.ctx.moveTo(-10, 0);
        this.ctx.lineTo(10, 0);
        this.ctx.moveTo(0, -10);
        this.ctx.lineTo(0, 10);
        this.ctx.moveTo(-5, 5);
        this.ctx.lineTo(5, -5);
        this.ctx.moveTo(5, 5);
        this.ctx.lineTo(-5, -5);
        this.ctx.strokeStyle = "#FFFFFF";
        this.ctx.stroke();
    }

    draw() {
        this.ctx.save();
        this.ctx.translate(this.x_pos, this.y_pos);
        this.ctx.scale(this.size, this.size);
        this.ctx.rotate(this.rotation);
        this.drawLines();
        this.ctx.restore();
    }

    update() {
        this.y_pos += 2;
        if (this.y_pos >= canvas.height) {
            this.x_pos = Math.floor(Math.random() * canvas.width);
            this.y_pos = -(20 * this.size);
        }
    }
}

let snowflakes = new Array();
let canvas;

function begin() {
    canvas = document.getElementById('snowflakes_canvas');
    const snowflakes_number = Math.max(Math.floor(Math.random() * canvas.width), 100);
    console.log("snowflakes #: " + snowflakes_number);
    console.log("canvas width: " + canvas.width);
    let ctx = canvas.getContext('2d');

    for (let i = 0; i < snowflakes_number; i++) {
        let x_pos = Math.floor(Math.random() * canvas.width);
        console.log(Math.floor(Math.random() * canvas.height))
        let y_pos = 1 - Math.floor(Math.random() * canvas.height);
        snowflakes.push(new Snowflake(x_pos, y_pos, ctx));
    }
    setInterval(drawSnowflakes, 100);
}

function drawSnowflakes() {
    canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);
    snowflakes.forEach(elem => {
        elem.draw();
        elem.update();
    });
}
