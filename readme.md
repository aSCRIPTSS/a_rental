# Vehicle Rental System for QBox

This is a vehicle rental system designed for the QBox framework in FiveM. It allows players to rent vehicles from specific locations, with options for car, boat, and air rentals. The system includes features such as blip creation, NPC interaction, payment handling, and vehicle return mechanics.

## Features
- **Blip System**: Automatically creates blips for rental locations based on the configuration.
- **NPC Interaction**: Players can interact with NPCs to rent vehicles.
- **Payment Options**: Supports both cash and bank payments.
- **Vehicle Spawning**: Spawns vehicles at designated locations with proper handling of fuel and keys.
- **Vehicle Return**: Players can return rented vehicles and receive a partial refund.
- **Rental Papers**: Players receive rental papers as proof of rental, which are required to return the vehicle.
- **Configurable**: Easily configure rental locations, vehicles, and prices via the `Config.lua` file.

## Installation
1. **Download the Script**: Clone or download this repository into your `resources` folder.
2. **Add to server.cfg**: Ensure the script is started in your `server.cfg` file:
   ```plaintext
   ensure a_rental
   ```
3. **Configure**: Modify the `Config.lua` file to suit your server's needs.
4. **Restart the Server**: Restart your FiveM server to apply the changes.

## Configuration
The `Config.lua` file allows you to customize the rental system. Below are the key configuration options:

### Blip Settings
- `sprite`: The sprite ID for the blip.
- `display`: The display mode for the blip.
- `scale`: The scale of the blip.
- `colour`: The color of the blip.

### Rental Locations
- `ShowBlip`: Whether to show a blip for the rental location.
- `Type`: The type of rental (car, boat, air).
- `Npc`: Configuration for the NPC, including coordinates, model, and scenario.
- `VehicleSpawn`: Coordinates and headings for vehicle spawn points.

### Vehicles
- `name`: The display name of the vehicle.
- `modelName`: The model name of the vehicle.
- `price`: The rental price.
- `needLicense`: Whether a driver's license is required to rent the vehicle.
- `menuIcon`: The icon displayed in the rental menu.
- `type`: The type of vehicle (car, boat, air).

## Usage
### Rent a Vehicle:
1. Approach a rental NPC.
2. Interact with the NPC to open the rental menu.
3. Select a vehicle and choose a payment method (cash or bank).
4. The vehicle will spawn at the designated location.

### Return a Vehicle:
1. Drive the rented vehicle back to the rental location.
2. Interact with the NPC to return the vehicle.
3. Ensure you have the rental papers in your inventory.
4. You will receive a partial refund upon returning the vehicle.

## Dependencies
- **QBox Framework**
- **ox_target** (for NPC interaction)
- **ox_inventory** (for rental papers)
- **cdn-fuel** (for fuel management)

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/aSCRIPTSS/a_rental/blob/main/LICENSE) file for details.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.