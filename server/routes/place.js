const express = require('express');
const router = express.Router();
const Place = require('../models/Place');

router.get('/', async (req,res) => {
    try{
        const district = await Place.find();
        res.json(district);
    }
    catch(err){
        res.json({message:err});
    }
});

router.get('/:districtName', async (req, res) => {
    console.log(`[Place GET] ${req.params.districtName}`)
    try {
        const points = await Place.find({'name': req.params.districtName});
        res.json(points);   
    } catch (error) {
        res.json({message: error});
    }
});

router.post('/', async(req, res) => {
    console.log(`[Place POST]`)
    var jsonData = JSON.parse(req.body.listPoints)
    const place = new Place({
        name: req.body.name,
        listPoints: jsonData,
    });
    try {
        const savePlace = await place.save();
        res.json(savePlace);
    }
    catch(err){
        res.json({message: err});
    }
    console.log({place});
})

router.delete('/id', async (req, res) => {
    try {
        const removedPolicy = await Policy.deleteOne({_id: req.params.id}, (err) => {
            console.log(err);
        });
        res.json(removedPolicy);
    } catch (err) {
        res.json({message: err});
    }
});

module.exports = router;