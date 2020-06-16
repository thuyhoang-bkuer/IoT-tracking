const express = require('express');
const router = express.Router();
const User = require('../models/User');
router.get('/', async (req,res) => {
    try{
        const users = await User.find();
        res.json(users);
    }
    catch(err){
        res.json({message:err});
    }
});

router.post('/', async (req, res) => {
    const user = new User({
        email: req.body.email,
	username: req.body.username,
        password: req.body.password,
        admin: req.body.admin
    });
    try {
        const saveUser = await user.save();
        res.json(saveUser);
    }
    catch(err){
        res.json({message: err});
    }
});
router.get('/user/:userId', async (req, res) => {
    try {
        const users = await User.findById(req.params.userId)
        res.json(users);   
    } catch (error) {
        res.json({message: error});
    }
});
router.get('/admin/:adminId', async (req, res) => {
    try {
        const users = await User.findById(req.params.admin)
        res.json(users);   
    } catch (error) {
        res.json({message: error});
    }
});
router.get('/:userEmail', async (req, res) => {
    try {
        console.log("-----GET USER-------")
        const users = await User.find({'email': req.params.userEmail})
        res.json(users);   
    } catch (error) {
        res.json({message: error});
    }
});
router.delete('/:userId', async (req, res) => {
    try {
        const removedUser = await User.remove({_id: req.params.userId});
        res.json(removedUser);
    } catch (error) {
        res.json({message: err});
    }
});

router.patch('/:userId', async (req, res) => {
    try {
        const updatedUser = await User.updateOne(
            {
                _id: req.params.userId,
                
            },
            { $set: 
                {
                    //email: req.body.email,
                    //password: req.body.password, 
                    admin: req.body.admin
                }
            }
        );
        res.json(updatedUser);
    } catch (error) {
        res.json({message:error});
    }
});

module.exports = router;
