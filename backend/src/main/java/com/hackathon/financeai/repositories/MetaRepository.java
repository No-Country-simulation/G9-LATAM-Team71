package com.hackathon.financeai.repositories;

import com.hackathon.financeai.model.Meta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface MetaRepository extends JpaRepository<Meta, UUID> {
    List<Meta> findByUsuarioId(UUID usuarioId);
}
