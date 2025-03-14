# Vehicle Rental System for QBox

This is a vehicle rental system designed for the QBox framework in FiveM. It allows players to rent vehicles from specific locations, with options for car, boat, and air rentals. The system includes features such as blip creation, NPC interaction, payment handling, and vehicle return mechanics.

## Features
- **Blip System**: Automatically generates blips for rental locations based on the configuration.
- **NPC Interaction**: Players can interact with NPCs to rent vehicles.
- **Payment Options**: Supports both cash and bank payments.
- **Vehicle Spawning**: Spawns vehicles at designated locations with proper handling of fuel and keys.
- **Vehicle Return System**: Players can return rented vehicles and receive a partial refund.
- **Rental Papers**: Players receive rental papers as proof of rental, required for returning the vehicle.

## Installation

1. **Download the Script**: Clone or download the `a_rental` repository into your `resources` folder.
2. **Add to Server.cfg**: Ensure the script is started in your `server.cfg` file:
   ```plaintext
   ensure a_rental
   ```
3. **Configure the Script**: Modify the `Config.lua` file to suit your server's needs.
4. **Restart the Server**: Restart your FiveM server to apply the changes.

## Configuration
The `Config.lua` file allows you to customize the rental system. Below are the configurable settings:

### Blip Settings
- `sprite`: The display icon for the rental location.
- `display`: The display type of the blip.
- `colour`: The color of the blip on the map.
- `scale`: The size of the blip.

### Rental Locations
- `ShowBlip`: Enables/disables the blip for the rental location.
- `Type`: Specifies the type of rental (car, boat, air).
- `Npc`: Configuration for the NPC, including model, coordinates, and scenario.
- `VehicleSpawn`: Defines coordinates and headings for where the rented vehicles spawn.

### Vehicles
- `name`: The display name of the vehicle.
- `model`: The spawn name of the vehicle.
- `price`: The cost to rent the vehicle.
- `needLicense`: Determines if a driver's license is required.
- `menuIcon`: Icon used for displaying the vehicle in the rental menu.
- `type`: The category of the vehicle (car, boat, air).

### ox_inventory Item
To enable rental papers in ox_inventory, add the following item to your configuration:

```lua
['rentalpapers'] = {
    label = "Rental Papers",
    weight = 1,
    stack = false,
    close = false,
    description = "Rental Papers",
    client = {image = "rentalpapers.png"}
}
```

## Usage
### Rent a Vehicle:
1. Approach a rental NPC.
2. Interact with the NPC to open the rental menu.
3. Select a vehicle and choose a payment method (cash or bank).
4. The vehicle will spawn at the designated location.

### Return a Vehicle:
1. Drive the rented vehicle back to the rental location.
2. Interact with the NPC to return the vehicle.
3. Ensure you have the rental papers.

## Supported Frameworks
This script is designed for **QBox** but may also be compatible with **QBCore**.

## Dependencies
- **QBox Framework**
- **ox_target** (for NPC interaction)
- **ox_inventory** (for rental papers management)
- **cdn-fuel** (for fuel management)

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/aSCRIPTSS/a_rental) file for details.

## Contributing
Contributions, bug fixes, and feature requests are welcome! Please open an issue or submit a pull request if you have any improvements to suggest.