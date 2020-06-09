const express = require('express');
const router = express.Router();
const Location = require('../models/Location');
router.get('/', async (req,res) => {
    try{
        const locations = await Location.find();
        res.json(locations);
    }
    catch(err){
        res.json({message:err});
    }
});

router.post('/', async (req, res) => {
    const location = new Location({
        deviceId: req.body.deviceId,
        timestamp: req.body.timestamp,
        coordinate: req.body.coordinate,
        user: req.body.user
    });
    try {
        const saveLoc = await location.save();
        res.json(saveLoc);
    }
    catch(err){
        res.json({message: err});
    }
});

router.get('/:deviceId', async (req, res) => {
    try {
        const locations = await Location.find({'deviceId': req.params.deviceId});  
        var output = [];

        for (var i = 0; i < locations.length; i++) {
            const loc_lat_long = await Coordinate.findById(locations[i].coordinate);
            output[i] = {
                deviceId: locations[i].deviceId,
                latitude: loc_lat_long.latitude,
                longitude: loc_lat_long.longitude,
                timestamp: locations[i].timestamp,
                user: locations[i].user 
            };
        }
        output.sort((a,b) => (a.timestamp > b.timestamp) ? 1 : ((b.timestamp > a.timestamp) ? -1 : 0)); 
        console.log(output)
        res.json(output);   
    } catch (error) {
        res.json({message: error});
    }
});
// router.delete('/:postId', async (req, res) => {
//     try {
//         const removedPost = await Location.remove({_id: req.params.postId});
//         res.json(removedPost);
//     } catch (error) {
//         res.json({message: err});
//     }
// });


// router.patch('/:postId', async (req, res) => {
//     try {
//         const updatedPost = await Post.updateOne(
//             {_id: req.params.postId}, 
//             { $set: { title: req.body.title}}
//         );
//         res.json(updatedPost);
//     } catch (error) {
//         res.json({message:error});
//     }
    
// });

module.exports = router;
