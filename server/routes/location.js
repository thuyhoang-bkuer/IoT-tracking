const express = require('express');
const router = express.Router();
const Location = require('../models/Location');
const Coordinate = require('../models/Coordinate');
router.get('/', async (req, res) => {
    try {
        const locations = await Location.find();
        res.json(locations);
    } catch (err) {
        res.json({
            message: err
        });
    }
});

router.post('/', async (req, res) => {
    console.log('--- POST Location ---');
    const coordinate = new Coordinate({
        longitude: req.body.longitude,
        latitude: req.body.latitude
    })
    const saveCoor = await coordinate.save();

    //const recent_coor = await Coordinate.find({'longitude': req.body.longitude, 'latitude': req.body.latitude});  
    const location = new Location({
        deviceId: req.body.deviceId,
        timestamp: req.body.timestamp,
        coordinate: saveCoor._id,
        user: req.body.user
    });
    try {
        const saveLoc = await location.save();
        res.json(saveLoc);
    } catch (err) {
        res.json({
            message: err
        });
    }

    console.log({
        coordinate,
        location
    });
});

router.get('/:deviceId', async (req, res) => {
    console.log('--- GET History ---');
    try {
        const locations = await Location.find({
            'deviceId': req.params.deviceId
        });
        var positions = [];
        if (locations.length != 0) {
            for (var i = 0; i < locations.length; i++) {
                const coor = await Coordinate.findById(locations[i].coordinate);
                if (coor == null) continue;
                positions.push({
                    deviceId: locations[i].deviceId,
                    latitude: coor.latitude,
                    longitude: coor.longitude,
                    timestamp: locations[i].timestamp,
                    user: locations[i].user
                });
            }
            positions.sort((a, b) => (a.timestamp > b.timestamp) ? 1 : ((b.timestamp > a.timestamp) ? -1 : 0));
        }
        console.log({
            deviceId: req.params.deviceId,
            positions
        });
        res.json({
            deviceId: req.params.deviceId,
            positions
        });
    } catch (error) {
        res.json({
            message: error
        });
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