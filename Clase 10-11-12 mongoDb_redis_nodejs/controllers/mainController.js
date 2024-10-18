class MainController {
    constructor() {}

    index(req, res) {
        res.status(200).json({ message: 'This is the landing page NodeJs' });
    }
}

module.exports = new MainController();
