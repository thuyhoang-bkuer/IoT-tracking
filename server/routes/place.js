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
    try {
        const points = await Place.find({'name': req.params.districtName})
        res.json(points);   
    } catch (error) {
        res.json({message: error});
    }
});

router.post('/', async(req, res) => {
    const place = new Place({
        name: req.body.name,
        listPoints: req.body.listPoints,
    });
    try {
        const savePlace = await place.save();
        res.json(savePlace);
    }
    catch(err){
        res.json({message: err});
    }
})