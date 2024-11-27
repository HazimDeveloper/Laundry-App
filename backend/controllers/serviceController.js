const { Service } = require("../models");

const serviceController = {
  getAllServices: async (req, res) => {
    try {
      const services = await Service.findAll({
        attributes: ["id", "name", "description", "price"],
      });
      res.json(services);
    } catch (error) {
      console.error("Error retrieving services:", error);
    }
  },

  getServiceById: async (req, res) => {
    try {
      const { id } = req.params;
      const service = await Service.findByPk(id);

      if (!service) {
        res.status(404).json({ message: "Service not found" });
      }
      res.json(service);
    } catch (error) {
      console.error("Error retrieving service:", error);
      res
        .status(500)
        .json({ error: "An error occurred while retrieving the service" });
    }
  },

  createService: async (req, res) => {
    try {
      const { name, description, price } = req.body;
      const service = await Service.create({
        name,
        description,
        price,
      });
      res.status(201).json(service);
    } catch (error) {
      console.error("Error creating service:", error);
      res
        .status(500)
        .json({ error: "An error occurred while creating the service" });
    }
  },

  updateService: async (req, res) => {
    try {
      const { id } = req.params;
      const { name, description, price } = req.body;

      const service = await Service.findByPk(id);

      if (!service) {
        return res.status(404).json({ message: "Service not found" });
      }

      await service.update({
        name,
        description,
        price,
      });

      res.json(service);
    } catch (error) {
      console.error("Error updating service:", error);
      res
        .status(500)
        .json({ error: "An error occurred while updating the service" });
    }
  },
  deleteService: async (req, res) => {
    try {
      const { id } = req.params;
      const service = await Service.findByPk(id);

      if (!service) {
        return res.status(404).json({ error: "Service not found" });
      }

      await service.destroy();
      res.json({ message: "Service deleted successfully" });
    } catch (error) {
      console.error("Error deleting service:", error);
      res.status(500).json({ error: "Failed to delete service" });
    }
  },
};

module.exports = serviceController
